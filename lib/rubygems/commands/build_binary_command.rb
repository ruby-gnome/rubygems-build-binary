require "fileutils"
require "tmpdir"

require "rubygems/dependency_installer"

class Gem::Commands::BuildBinaryCommand < Gem::Command
  def initialize
    super("build_binary",
          "Build a binary gem for the current platform",
          requirements: [])

    add_option("--add-requirement=REQUIREMENT",
               "Add REQUIREMENT to spec.requirements",
               "You can specify this option multiple times",
               "to add multiples requirements") do |value, options|
      options[:requirements] << value
    end
  end

  def arguments
    "GEM_FILE source gem file to build"
  end

  def description
    "Build binary gem"
  end

  def usage
    "#{program_name} GEM_FILE"
  end

  def execute
    gem_file, = options[:args]
    Dir.mktmpdir do |dir|
      options[:install_dir] = dir

      name, version = install_gem(gem_file)

      spec_path = File.join(dir, "specifications", "#{name}-#{version}.gemspec")
      spec = Gem::Specification.load(spec_path)

      dist_dir = File.join(dir, "dist")
      adjust_spec(spec, dist_dir)

      rebuild_gem(spec,
                  dist_dir,
                  "#{name}-#{version}-#{Gem::Platform.local}.gem")
    end
  end

  private
  def install_gem(gem_file)
    dependency_installer = Gem::DependencyInstaller.new(options)
    requirement = Gem::Requirement.create(nil)
    request_set = dependency_installer.resolve_dependencies(gem_file,
                                                            requirement)
    request_set.install(options)

    name = request_set.dependencies[0].name
    version = request_set.dependencies[0].requirement.requirements[0][1]
    [name, version]
  end

  def adjust_spec(spec, dist_dir)
    # gems/#{name}-#{version}/ ->
    # dist/
    FileUtils.cp_r(spec.gem_dir, dist_dir)

    # extensions/#{platform}/#{ruby_api_version}/#{name}-#{version}/ ->
    # dist/extension/#{platform}/#{ruby_api_version}/
    base_extension_dir = File.join("extension",
                                   Gem::Platform.local.to_s,
                                   Gem.extension_api_version)
    dist_extension_dir = File.join(dist_dir, base_extension_dir)
    FileUtils.mkdir_p(File.dirname(dist_extension_dir))
    FileUtils.cp_r(spec.extension_dir, dist_extension_dir)

    # Use all files.
    paths = Dir.glob("**/*", File::FNM_DOTMATCH, base: dist_dir)
    paths.reject! do |path|
      File.directory?(File.join(dist_dir, path))
    end
    spec.files = paths

    # We don't need to build extension.
    spec.extensions.clear
    # Add binary directory to require paths.
    spec.require_paths.unshift(base_extension_dir)
    # Use the current platform.
    spec.platform = Gem::Platform.local
    # Available only for the current Ruby.
    spec.required_ruby_version = required_ruby_version

    pp @options
    @options[:requirements].each do |requirement|
      spec.requirements << requirement
    end
  end

  def required_ruby_version
    major, minor = Gem.ruby_version.to_s.split(".")[0, 2]
    start_version = "#{major}.#{minor}.0"
    end_version = "#{major}.#{minor.next}.0.dev"
    Gem::Requirement.new([">= #{start_version}", "< #{end_version}"])
  end

  def rebuild_gem(spec, dist_dir, output_path)
    output_path = File.expand_path(output_path)
    Dir.chdir(dist_dir) do
      Gem::Package.build(spec, true, false, output_path)
    end
  end
end

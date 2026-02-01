# -*- ruby -*-

require "bundler/gem_helper"

base_dir = File.dirname(__FILE__)
helper = Bundler::GemHelper.new(base_dir)
def helper.version_tag
  version
end
helper.install

release_task = Rake.application["release"]
# We use Trusted Publishing.
release_task.prerequisites.delete("build")
release_task.prerequisites.delete("release:rubygem_push")
release_task_comment = release_task.comment
if release_task_comment
  release_task.clear_comments
  release_task.comment = release_task_comment.gsub(/ and build.*$/, "")
end

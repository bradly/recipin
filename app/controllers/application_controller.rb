class ApplicationController < ActionController::Base
  private

  include Clearance::Controller

  class_attribute :feed_enabled, default: true, instance_writer: false
  helper_method :feed_enabled?

  def self.feed_enabled
    self.feed_enabled = false
  end

  def feed_enabled?
    self.class.feed_enabled
  end

  def self.expose(*actions)
    actions.each { define_method(_1) {} }
  end
end

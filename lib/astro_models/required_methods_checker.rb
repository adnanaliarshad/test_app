# This module contains method, that checks 'self' for responding to
# required methods and for not blank output 
# Methods are contained in REQUIRED_METHODS. Format of REQUIRED_METHODS:
# REQUIRED_METHODS = [ methods ]
# e.g.: [ 'title', 'body', 'nid', 'slug' ]
module AstroModels::RequiredMethodsChecker

  def check_for_required_methods
    methods = self.class::REQUIRED_METHODS
    missed_methods = []
    methods.each do |method|
      missed_methods << method if !self.respond_to?(method) || self.send(method).blank?
    end
    raise "There is no required tags: #{missed_methods.join(", ")}" unless missed_methods.empty?
    true
  end

end

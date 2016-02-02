require 'trice/repository'

module Trice
  module ReferenceTimeAccessor
    def self.repository
      @repository ||= Repository.new
    end

    delegate :reference_time=, :reference_time, :with_reference_time, to: 'Trice::ReferenceTimeAccessor.repository'
  end
end

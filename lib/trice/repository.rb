module Trice
  class Repository
    def initialize
      @backend = ThreadLocalBackend.new('trice.reference_time'.freeze)
    end

    def reference_time=(time)
      unless time.nil? || time.acts_like?(:time)
        raise ArgumentError, "#{time.inspect} is not behave like time"
      end
      @backend.set(time)
    end

    def reference_time
      @backend.get || raise(NoReferenceTime)
    end

    def with_reference_time(time, &block)
      original = @backend.get

      begin
        self.reference_time = time
        yield time
      ensure
        self.reference_time = original
      end
    end
  end

  class ThreadLocalBackend
    def initialize(key)
      @key = key
    end

    def set(time)
      Thread.current[@key] = time
    end

    def get
      Thread.current[@key]
    end
  end
end

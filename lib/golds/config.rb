module Golds
  class RootDirectoryNotFound < StandardError
  end

  class LedgerFileNotFound < StandardError
  end

  class CashflowMappingFileNotFound < StandardError
  end

  class Config
    attr_reader :options

    def initialize options
      @options = options
    end

    def root
      options.fetch(:root) { ENV.fetch("GOLDS_ROOT", "") }.tap do |dir|
        Dir.exists?(dir) or raise RootDirectoryNotFound
      end
    end

    def file
      options.fetch(:file) { File.join(root, "golds.txt") }.tap do |filename|
        File.exists?(filename) or raise LedgerFileNotFound
      end
    end

    def pnl_mapping
      options.fetch(:pnl_mapping) { File.join(root, "pnl.txt") }.tap do |filename|
        File.exists?(filename) or raise CashflowMappingFileNotFound
      end
    end

    def cashflow_mapping
      options.fetch(:cashflow_mapping) { File.join(root, "cashflow.txt") }.tap do |filename|
        File.exists?(filename) or raise CashflowMappingFileNotFound
      end
    end
  end
end

require 'donjon/commands/base'

module Donjon
  module Commands
    Base.class_eval do
      desc 'config:set KEY=VALUE ...', 'Encrypts KEY and VALUE in the vault'
      decl 'config:set'

      desc 'config:get KEY...', 'Decrypts the value for KEY from the vault'
      decl 'config:get'
      
      desc 'config:mget [REGEXP]', 'Decrypts multiple keys (all readable by default)'
      decl 'config:mget'
      
      private
      
      def config_set(*keyvals)
        keyvals.each do |keyval|
          m = /([^=]*)=(.*)/.match(keyval)
          key = m[1]
          value = m[2]
          database[key] = value
        end
      end

      def config_get(*keys)
        keys.each do |key|
          puts "#{key}: #{database[key]}"
        end
      end

      def config_mget(regexp = nil)
        regexp = Regexp.new(regexp) if regexp
        database.each do |key, value|
          next if regexp && regexp !~ key
          puts "#{key}: #{value}"
        end
      end
    end
  end
end
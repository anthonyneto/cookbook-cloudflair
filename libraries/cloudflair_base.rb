module CloudflairCookbook
  class CloudflairBase < ChefCompat::Resource
    require 'cloudflair'
    require 'resolv'

    #########
    # Classes
    #########

    class UnorderedArray < Array
      def ==(other)
        # If I (desired env) am a subset of the current env, let == return true
        other.is_a?(Array) && all? { |val| other.include?(val) }
      end
    end

    class PartialHash < Hash
      def ==(other)
        other.is_a?(Hash) && all? { |key, val| other.key?(key) && other[key] == val }
      end
    end

    ################
    # Type Constants
    ################

    ArrayType = property_type(
      is: [Array, nil],
      coerce: proc { |v| v.nil? ? nil : Array(v) }
    ) unless defined?(ArrayType)

    Boolean = property_type(
      is: [true, false],
      default: false
    ) unless defined?(Boolean)

    NonEmptyArray = property_type(
      is: [Array, nil],
      coerce: proc { |v| Array(v).empty? ? nil : Array(v) }
    ) unless defined?(NonEmptyArray)

    UnorderedArrayType = property_type(
      is: [UnorderedArray, nil],
      coerce: proc { |v| v.nil? ? nil : UnorderedArray.new(Array(v)) }
    ) unless defined?(UnorderedArrayType)

    PartialHashType = property_type(
      is: [PartialHash, nil],
      coerce: proc { |v| v.nil? ? nil : PartialHash[v] }
    ) unless defined?(PartialHashType)
  end
end

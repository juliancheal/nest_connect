module NestConnect
  class Device
    class Structure
      def self.from_hash_collection(hash)
        hash.values.map { |value| new(value) }
      end

      def initialize(api_class: NestConnect::API::Devices::Structure, **args)
        @api_class = api_class
        args.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def reload
        api_runner.get.body.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      attr_reader(
        :co_alarm_state,
        :country_code,
        :eta_begin,
        :peak_period_end_time,
        :peak_period_start_time,
        :postal_code,
        :rhr_enrollment,
        :smoke_alarm_state,
        :structure_id,
        :time_zone,
        :wheres,
        :wwn_security_state
      )

      def thermostats
        @thermostats.to_a.map do |device_id|
          Device::Thermostat.new(device_id: device_id)
        end
      end

      def protects
        @smoke_alarm_state.to_a.map do |device_id|
          Device::Protect.new(device_id: device_id)
        end
      end

      def cameras
        @cameras.to_a.map do |device_id|
          Device::Camera.new(device_id: device_id)
        end
      end

      AWAY_VALUES = ['home', 'away']

      attr_reader :away

      def away=(value)
        unless AWAY_VALUES.include?(value)
          raise ValueError.new("away must be #{AWAY_VALUES}")
        end

        api_runner.put({away: value})
        @away = value
      end

      attr_reader :name

      def name=(value)
        normalized_value = value.to_s

        api_runner.put({name: normalized_value})
        @name = normalized_value
      end

      private

        attr_reader :api_class

        def api_runner
          api_class.new(structure_id)
        end
    end
  end
end
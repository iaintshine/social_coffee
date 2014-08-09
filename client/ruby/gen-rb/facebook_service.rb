#
# Autogenerated by Thrift Compiler (1.0.0-dev)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'fb303_types'

module FacebookService
  class Client
    include ::Thrift::Client

    def getName()
      send_getName()
      return recv_getName()
    end

    def send_getName()
      send_message('getName', GetName_args)
    end

    def recv_getName()
      result = receive_message(GetName_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getName failed: unknown result')
    end

    def getVersion()
      send_getVersion()
      return recv_getVersion()
    end

    def send_getVersion()
      send_message('getVersion', GetVersion_args)
    end

    def recv_getVersion()
      result = receive_message(GetVersion_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getVersion failed: unknown result')
    end

    def getStatus()
      send_getStatus()
      return recv_getStatus()
    end

    def send_getStatus()
      send_message('getStatus', GetStatus_args)
    end

    def recv_getStatus()
      result = receive_message(GetStatus_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getStatus failed: unknown result')
    end

    def getStatusDetails()
      send_getStatusDetails()
      return recv_getStatusDetails()
    end

    def send_getStatusDetails()
      send_message('getStatusDetails', GetStatusDetails_args)
    end

    def recv_getStatusDetails()
      result = receive_message(GetStatusDetails_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getStatusDetails failed: unknown result')
    end

    def getCounters()
      send_getCounters()
      return recv_getCounters()
    end

    def send_getCounters()
      send_message('getCounters', GetCounters_args)
    end

    def recv_getCounters()
      result = receive_message(GetCounters_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getCounters failed: unknown result')
    end

    def getCounter(key)
      send_getCounter(key)
      return recv_getCounter()
    end

    def send_getCounter(key)
      send_message('getCounter', GetCounter_args, :key => key)
    end

    def recv_getCounter()
      result = receive_message(GetCounter_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getCounter failed: unknown result')
    end

    def setOption(key, value)
      send_setOption(key, value)
      recv_setOption()
    end

    def send_setOption(key, value)
      send_message('setOption', SetOption_args, :key => key, :value => value)
    end

    def recv_setOption()
      result = receive_message(SetOption_result)
      return
    end

    def getOption(key)
      send_getOption(key)
      return recv_getOption()
    end

    def send_getOption(key)
      send_message('getOption', GetOption_args, :key => key)
    end

    def recv_getOption()
      result = receive_message(GetOption_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getOption failed: unknown result')
    end

    def getOptions()
      send_getOptions()
      return recv_getOptions()
    end

    def send_getOptions()
      send_message('getOptions', GetOptions_args)
    end

    def recv_getOptions()
      result = receive_message(GetOptions_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getOptions failed: unknown result')
    end

    def getCpuProfile(profileDurationInSec)
      send_getCpuProfile(profileDurationInSec)
      return recv_getCpuProfile()
    end

    def send_getCpuProfile(profileDurationInSec)
      send_message('getCpuProfile', GetCpuProfile_args, :profileDurationInSec => profileDurationInSec)
    end

    def recv_getCpuProfile()
      result = receive_message(GetCpuProfile_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getCpuProfile failed: unknown result')
    end

    def aliveSince()
      send_aliveSince()
      return recv_aliveSince()
    end

    def send_aliveSince()
      send_message('aliveSince', AliveSince_args)
    end

    def recv_aliveSince()
      result = receive_message(AliveSince_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'aliveSince failed: unknown result')
    end

    def reinitialize()
      send_reinitialize()
    end

    def send_reinitialize()
      send_message('reinitialize', Reinitialize_args)
    end
    def shutdown()
      send_shutdown()
    end

    def send_shutdown()
      send_message('shutdown', Shutdown_args)
    end
  end

  class Processor
    include ::Thrift::Processor

    def process_getName(seqid, iprot, oprot)
      args = read_args(iprot, GetName_args)
      result = GetName_result.new()
      result.success = @handler.getName()
      write_result(result, oprot, 'getName', seqid)
    end

    def process_getVersion(seqid, iprot, oprot)
      args = read_args(iprot, GetVersion_args)
      result = GetVersion_result.new()
      result.success = @handler.getVersion()
      write_result(result, oprot, 'getVersion', seqid)
    end

    def process_getStatus(seqid, iprot, oprot)
      args = read_args(iprot, GetStatus_args)
      result = GetStatus_result.new()
      result.success = @handler.getStatus()
      write_result(result, oprot, 'getStatus', seqid)
    end

    def process_getStatusDetails(seqid, iprot, oprot)
      args = read_args(iprot, GetStatusDetails_args)
      result = GetStatusDetails_result.new()
      result.success = @handler.getStatusDetails()
      write_result(result, oprot, 'getStatusDetails', seqid)
    end

    def process_getCounters(seqid, iprot, oprot)
      args = read_args(iprot, GetCounters_args)
      result = GetCounters_result.new()
      result.success = @handler.getCounters()
      write_result(result, oprot, 'getCounters', seqid)
    end

    def process_getCounter(seqid, iprot, oprot)
      args = read_args(iprot, GetCounter_args)
      result = GetCounter_result.new()
      result.success = @handler.getCounter(args.key)
      write_result(result, oprot, 'getCounter', seqid)
    end

    def process_setOption(seqid, iprot, oprot)
      args = read_args(iprot, SetOption_args)
      result = SetOption_result.new()
      @handler.setOption(args.key, args.value)
      write_result(result, oprot, 'setOption', seqid)
    end

    def process_getOption(seqid, iprot, oprot)
      args = read_args(iprot, GetOption_args)
      result = GetOption_result.new()
      result.success = @handler.getOption(args.key)
      write_result(result, oprot, 'getOption', seqid)
    end

    def process_getOptions(seqid, iprot, oprot)
      args = read_args(iprot, GetOptions_args)
      result = GetOptions_result.new()
      result.success = @handler.getOptions()
      write_result(result, oprot, 'getOptions', seqid)
    end

    def process_getCpuProfile(seqid, iprot, oprot)
      args = read_args(iprot, GetCpuProfile_args)
      result = GetCpuProfile_result.new()
      result.success = @handler.getCpuProfile(args.profileDurationInSec)
      write_result(result, oprot, 'getCpuProfile', seqid)
    end

    def process_aliveSince(seqid, iprot, oprot)
      args = read_args(iprot, AliveSince_args)
      result = AliveSince_result.new()
      result.success = @handler.aliveSince()
      write_result(result, oprot, 'aliveSince', seqid)
    end

    def process_reinitialize(seqid, iprot, oprot)
      args = read_args(iprot, Reinitialize_args)
      @handler.reinitialize()
      return
    end

    def process_shutdown(seqid, iprot, oprot)
      args = read_args(iprot, Shutdown_args)
      @handler.shutdown()
      return
    end

  end

  # HELPER FUNCTIONS AND STRUCTURES

  class GetName_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetName_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetVersion_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetVersion_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetStatus_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetStatus_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::I32, :name => 'success', :enum_class => ::Fb_status}
    }

    def struct_fields; FIELDS; end

    def validate
      unless @success.nil? || ::Fb_status::VALID_VALUES.include?(@success)
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field success!')
      end
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetStatusDetails_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetStatusDetails_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetCounters_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetCounters_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::I64}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetCounter_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    KEY = 1

    FIELDS = {
      KEY => {:type => ::Thrift::Types::STRING, :name => 'key'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetCounter_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::I64, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class SetOption_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    KEY = 1
    VALUE = 2

    FIELDS = {
      KEY => {:type => ::Thrift::Types::STRING, :name => 'key'},
      VALUE => {:type => ::Thrift::Types::STRING, :name => 'value'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class SetOption_result
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetOption_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    KEY = 1

    FIELDS = {
      KEY => {:type => ::Thrift::Types::STRING, :name => 'key'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetOption_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetOptions_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetOptions_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetCpuProfile_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    PROFILEDURATIONINSEC = 1

    FIELDS = {
      PROFILEDURATIONINSEC => {:type => ::Thrift::Types::I32, :name => 'profileDurationInSec'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetCpuProfile_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class AliveSince_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class AliveSince_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::I64, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Reinitialize_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Reinitialize_result
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Shutdown_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Shutdown_result
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

end


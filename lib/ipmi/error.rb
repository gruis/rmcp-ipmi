module IPMI
  module Error
    class StandardError < ::StandardError
      include Error
    end
    class Checksum < StandardError; end
    # Command could not be processed because command processing
    # resources are temporarily unavailable.
    class NodeBusy < StandardError; end
    # Used to indicate an unrecognized or unsupported command.
    class InvalidCommand < StandardError; end
    class InvalidCommandForLun < StandardError; end
    # Timeout while processing command. Response unavailable.
    class Timeout < StandardError; end
    # Command could not be completed because of a lack of storage space
    # required to execute the given command operation
    class OutOfSpace < StandardError; end
    class ReservationCanceledOrInvalidReservationID < StandardError; end
    class RequestDataTruncated < StandardError; end
    class RequestDataLenInvalid < StandardError; end
    # Request data field length limit exceeded
    class RequestDataFieldLenExceeded < StandardError; end
    # One or more parameters in the data field of the Request are out of
    # range. This is different from ‘Invalid data field’ (CCh) code in
    # that it indicates that the erroneous field(s) has a contiguous
    # range of possible values
    class ParameterOutOfRange < StandardError; end
    # Cannot return number of requested data bytes.
    class InsufficientBytes < StandardError; end
    # Requested Sensor, data, or record not present
    class NotPresent < StandardError; end
    # Invalid data field in Request
    class InvalidDataField < StandardError; end
    # Command illegal for specified sensor or record type
    class CommandIllegal < StandardError; end
    # Command response could not be provided.
    class NoResponse < StandardError; end
    # This completion code is for devices which cannot return the
    # response that was returned for the original instance of the
    # request. Such devices should provide separate commands that allow
    # the completion status of the original request to be determined. An
    # Event Receiver does not use this completion code, but returns the
    # 00h completion code in the response to (valid) duplicated
    # requests.
    class DuplicateRequest < NoResponse; end
    # Command response could not be provided. SDR Repository in update mode
    class SDRUpdateMode < NoResponse; end
    # Command response could not be provided. Device in firmware update mode
    class FirmwareUpdateMode < NoResponse; end
    # Command response could not be provided. BMC initialization or
    # initialization agent in progress
    class BMCInitInProgress < NoResponse; end
    # Cannot deliver request to selected destination. E.g. this code can
    # be returned if a request message is targeted to SMS, but receive
    # message queue reception is disabled for the particular channel.",
    class DestinationUnavailable < StandardError; end
    # Cannot execute command due to insufficient privilege level or
    # other security- based restriction (e.g. disabled for ‘firmware
    # firewall’)
    class PrivilegeError < StandardError; end
    # Command, or request parameter(s), not supported in present state.
    class CannotExecute < StandardError; end
    # Cannot execute command. Parameter is illegal because command
    # sub-function has been disabled or is unavailable (e.g. disabled
    # for ‘firmware firewall’).
    class SubFunctionDisabled < CannotExecute; end
    class UnspecifiedError < StandardError; end
  end # module::Error
end # module::IPMI

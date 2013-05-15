require "ipmi/error"
module IPMI
  NET_FUNC_CODES = {
                     # REQ, RESP
    :chassis      => [0x00, 0x01],
                     # REQ, RESP
    :bridge       => [0x02, 0x03],
                     # REQ, RESP
    :sensor_event => [0x04, 0x05],
                     # REQ, RESP
    :app          => [0x06, 0x07],
                     # REQ, RESP
    :firmware     => [0x08, 0x09],
                     # REQ, RESP
    :storage      => [0x0a, 0x0b],
                     # REQ, RESP
    :transport    => [0x0c, 0x0d],

  }

  CMD_CODES = {
    :app => {
      :get_device_id                            => 0x01,
      :cold_reset                               => 0x02,
      :warm_reset                               => 0x03,
      :get_self_test_results                    => 0x04,
      :manufacture_test_on                      => 0x05,
      :set_acpi_power_state                     => 0x06,
      :get_acpi_power_state                     => 0x07,
      :get_device_guid                          => 0x08,
      :get_netfn_support                        => 0x09,
      :get_command_support                      => 0x0A,
      :get_command_sub_function_support         => 0x0B,
      :get_configurable_commands                => 0x0C,
      :get_configurable_command_sub_functions   => 0x0D,
      :reset_watchdog_timer                     => 0x22,
      :set_watchdog_timer                       => 0x24,
      :get_watchdog_timer                       => 0x25,
      :set_bmc_global_enables                   => 0x2E,
      :get_bmc_global_enables                   => 0x2F,
      :clear_message_buffer_flags               => 0x30,
      :get_message_buffer_flags                 => 0x31,
      :enable_message_channel_receive           => 0x32,
      :get_message                              => 0x33,
      :send_message                             => 0x34,
      :read_event_message_buffer                => 0x35,
      :get_system_interface_capabilities        => 0x57,
      :get_bt_interface_capabilities            => 0x36,
      :master_write_read                        => 0x52,
      :get_system_guid                          => 0x37,
      :set_system_info_parameters               => 0x58,
      :get_system_info_parameters               => 0x59,
      :get_channel_authentication_capabilities  => 0x38,
      :get_channel_cipher_suites                => 0x54,
      :get_session_challenge                    => 0x39,
      :activate_session                         => 0x3A,
      :set_session_privilege_level              => 0x3B,
      :close_session                            => 0x3C,
      :get_session_information                  => 0x3D,
      :get_authentication_code                  => 0x3F,
      :set_channel_access                       => 0x40,
      :get_channel_access                       => 0x41,
      :get_channel_info                         => 0x42,
      :active_payload                           => 0x48,
      :deactivate_payload                       => 0x49,
      :get_payload_activation_status            => 0x4A,
      :get_payload_instance_info                => 0x4B,
      :set_user_payload_access                  => 0x4C,
      :get_user_payload_access                  => 0x4D,
      :get_channel_payload_support              => 0x4E,
      :get_channel_payload_version              => 0x4F,
      :get_channel_oem_payload_info             => 0x50,
      :suspend_resume_payload_activation_status => 0x55,
      :set_channel_security_keys                => 0x56,
      :set_user_access                          => 0x43,
      :get_user_access                          => 0x44,
      :set_user_name                            => 0x45,
      :get_user_name                            => 0x46,
      :set_user_password                        => 0x47,
      :set_command_enables                      => 0x60,
      :get_command_enables                      => 0x61,
      :set_command_sub_function_enables         => 0x62,
      :get_command_sub_function_enables         => 0x63,
      :get_oem_netfn_iana_support               => 0x64
    },
    :transport => {
      :set_lan_configuration_parameters => 0x01,
      :get_lan_configuration_parameters => 0x02,
      :suspend_bmc_arp                  => 0x03,
      :get_ip_udp_rmcp_statistics       => 0x04,
      :set_serial_modem_configuation    => 0x10,
      :get_serial_modem_configuration   => 0x11,
      :set_serial_modem_mux             => 0x12,
      :get_tap_response_codes           => 0x13,
      :set_ppp_udp_proxy_transmit_data  => 0x14,
      :get_ppp_udp_proxy_transmit_data  => 0x15,
      :send_ppp_udp_proxy_packet        => 0x16,
      :get_ppp_udp_proxy_receive_data   => 0x17,
      :serial_modem_connection_active   => 0x18,
      :callback                         => 0x19,
      :set_user_callback_options        => 0x1A,
      :get_user_callback_options        => 0x1B,
      :sol_activating                   => 0x20,
      :set_sol_configuration_parameters => 0x21,
      :get_sol_configuration_parameters => 0x22,
    },
    :chassis => {
      :get_chassis_capabilities => 0x00,
      :get_chassis_status       => 0x01,
      :chassis_control          => 0x02,
      :chassis_reset            => 0x03,
      :chassis_identify         => 0x04,
      :set_front_panel_button   => 0x0A,
      :set_chassis_capabilities => 0x05,
      :set_power_restore_policy => 0x06,
      :set_power_cycle_interval => 0x0B,
      :get_system_reset_cause   => 0x07,
      :set_system_boot_options  => 0x08,
      :get_system_boot_options  => 0x09,
      :get_poh_counter          => 0x0F
    },
    :storage => {
      :get_sel_info                       => 0x40,
      :get_sel_allocation_info            => 0x41,
      :reserve_sel                        => 0x42,
      :get_sel_entry                      => 0x43,
      :add_sel_entry                      => 0x44,
      :partial_add_sel_entry              => 0x45,
      :delete_sel_entry                   => 0x46,
      :clear_sel                          => 0x47,
      :get_sel_time                       => 0x48,
      :set_sel_time                       => 0x49,
      :get_sel_time_utc_offset            => 0x5C,
      :set_sel_time_utc_offset            => 0x5D,
      :get_auxiliary_log_status           => 0x5A,
      :set_auxiliary_log_status           => 0x5B,
      :get_sdr_repository_info            => 0x20,
      :get_sdr_repository_allocation_info => 0x21,
      :reserve_sdr_repository             => 0x22,
      :get_sdr                            => 0x23,
      :add_sdr                            => 0x24,
      :partial_add_sdr                    => 0x25,
      :delete_sdr                         => 0x26,
      :clear_sdr_repository               => 0x27,
      :get_sdr_repository_time            => 0x28,
      :set_sdr_repository_time            => 0x29,
      :enter_sdr_repository_update_mode   => 0x2A,
      :exit_sdr_repository_update_mode    => 0x2B,
      :run_initialization_agent           => 0x2C,
      :get_fru_inventory_area_info        => 0x10,
      :read_fru_inventory_data            => 0x11,
      :write_fru_inventory_data           => 0x12
    },
    :sensor_event => {
      :set_event_receiver                  => 0x00,
      :get_event_receiver                  => 0x01,
      :platform_event_event_message        => 0x02,
      :get_pef_capabilities                => 0x10,
      :arm_pef_postpone_timer              => 0x11,
      :set_pef_configuration_parameters    => 0x12,
      :get_pef_configuration_parameters    => 0x13,
      :set_last_processed_event_id         => 0x14,
      :get_last_processed_event_id         => 0x15,
      :alert_immediate                     => 0x16,
      :pet_acknowledge                     => 0x17,
      :get_device_sdr_info                 => 0x20,
      :get_device_sdr                      => 0x21,
      :reserve_device_sdr_repository       => 0x22,
      :get_sensor_reading_factors          => 0x23,
      :set_sensor_hysteresis               => 0x24,
      :get_sensor_hysteresis               => 0x25,
      :set_sensor_threshold                => 0x26,
      :get_sensor_threshold                => 0x27,
      :set_sensor_event_enable             => 0x28,
      :get_sensor_event_enable             => 0x29,
      :re_arm_sensor_events                => 0x2A,
      :get_sensor_event_status             => 0x2B,
      :get_sensor_reading                  => 0x2D,
      :set_sensor_type                     => 0x2E,
      :get_sensor_type                     => 0x2F,
      :set_sensor_reading_and_event_status => 0x30
    },
    :bridge => {
      :get_bridge_state          => 0x00,
      :set_bridge_state          => 0x01,
      :get_icmb_address          => 0x02,
      :set_icmb_address          => 0x03,
      :set_bridge_proxyaddress   => 0x04,
      :get_bridge_statistics     => 0x05,
      :get_icmb_capabilities     => 0x06,
      :clear_bridge_statistics   => 0x08,
      :get_bridge_proxy_address  => 0x09,
      :get_icmb_connector_info   => 0x0A,
      :get_icmb_connection_id    => 0x0B,
      :send_icmb_connection_id   => 0x0C,
      :prepare_for_discovery     => 0x10,
      :get_addresses             => 0x11,
      :set_discovered            => 0x12,
      :get_chassis_device_id     => 0x13,
      :set_chassis_device_id     => 0x14,
      :bridge_request            => 0x20,
      :bridge_message            => 0x21,
      :get_event_count           => 0x30,
      :set_event_destination     => 0x31,
      :set_event_reception_state => 0x32,
      :send_icmb_event_message   => 0x33,
      :get_event_destination     => 0x34,
      :get_event_reception_state => 0x35,
      :error_report              => 0xFF
    }
  }

  COMPLETION_CODES = {
    0x00 => "Command Completed Normally.",
    0xC0 => Error::NodeBusy,
    0xC1 => Error::InvalidCommand,
    0xC2 => Error::InvalidCommandForLun,
    0xC3 => Error::Timeout,
    0xC4 => Error::OutOfSpace,
    0xC5 => Error::ReservationCanceledOrInvalidReservationID,
    0xC6 => Error::RequestDataTruncated,
    0xC7 => Error::RequestDataLenInvalid,
    0xC8 => Error::RequestDataFieldLenExceeded,
    0xC9 => Error::ParameterOutOfRange,
    0xCA => Error::InsufficientBytes,
    0xCB => Error::NotPresent,
    0xCC => Error::InvalidDataField,
    0xCD => Error::CommandIllegal,
    0xCE => Error::NoResponse,
    0xCF => Error::DuplicateRequest,
    0xD0 => Error::SDRUpdateMode,
    0xD1 => Error::FirmwareUpdateMode,
    0xD2 => Error::BMCInitInProgress,
    0xD3 => Error::DestinationUnavailable,
    0xD4 => Error::PrivilegeError,
    0xD5 => Error::CannotExecute,
    0xD6 => Error::SubFunctionDisabled,
    0xFF => Error::UnspecifiedError
  }
end
require "ipmi/proto"
require "ipmi/session"
require "ipmi/message"

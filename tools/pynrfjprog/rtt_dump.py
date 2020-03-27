"""
    Example code used in order to test the pynrfjprog High Level API.
"""

from __future__ import print_function
import argparse

# Import pynrfjprog API module
from pynrfjprog import HighLevel
from pynrfjprog import Parameters


def run(snr):
    """
    Run example script.
    @param int snr: Specify serial number of DK to run example on.
    """
    print('# Opening High Level API instance and initializing a probe handle.')
    # Initialize an API object.
    # Open the loaded DLL and connect to an emulator probe.
    with HighLevel.API() as api:
        # Initialize the probe connection.
        # The device family is automatically detected, and the correct sub dll is loaded.
        with HighLevel.DebugProbe(api, snr) as probe:
            print('# Reading out device information.')
            # Read out device information
            device_info = probe.get_device_info()
            print(device_info)

            # RTT
            if probe.is_rtt_started() == False:
                probe.rtt_start()
            print("is_rtt_started", probe.is_rtt_started())
            print("rtt_is_control_block_found", probe.rtt_is_control_block_found())
            print("rtt_read_channel_count", probe.rtt_read_channel_count())
            print("rtt_read_channel_info - UP_DIRECTION", probe.rtt_read_channel_info(0, Parameters.RTTChannelDirection.UP_DIRECTION))
            print("rtt_read_channel_info - DOWN_DIRECTION", probe.rtt_read_channel_info(0, Parameters.RTTChannelDirection.DOWN_DIRECTION))
            print("rtt_read", probe.rtt_read(0, 1024))

    print('# Example done...')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--serial',  type=int, help="Serial number to test.")
    args = parser.parse_args()

    run(args.serial)

#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

""" Generate ZMQ keys and put them to the etcdctl """
import argparse
import logging
import os
import sys
import traceback
import eis_integ


def parse_arguments(_cli_args):
    """ Parse argument passed to function """
    parser = argparse.ArgumentParser(description="Specify Application name")
    parser.add_argument("app", help= "Name of the client application")
    return parser.parse_args()

def main(args):
    """ Calls the eis_integ.etcd_put_json function to add the contents of the json file
        to the etcd database """
    eis_integ.init_logger()

    os.environ["ETCDCTL_ENDPOINTS"] = "https://" + \
        eis_integ.extract_etcd_endpoint()

    eis_integ.check_path_variable("ETCDCTL_CACERT", os.environ.get("ETCDCTL_CACERT"))
    eis_integ.check_path_variable("ETCDCTL_CERT", os.environ.get("ETCDCTL_CERT"))
    eis_integ.check_path_variable("ETCDCTL_KEY", os.environ.get("ETCDCTL_KEY"))

    logging.info("Generate ZMQ pair keys for {} and put them to the etcd database".format(args.app))

    eis_integ.put_zmqkeys(args.app)
    return eis_integ.CODES.NO_ERROR


if __name__ == '__main__':
    try:
        sys.exit(main(parse_arguments(sys.argv[1:])).value)
    except eis_integ.EisIntegError as exception:
        logging.error("Error while generating ZMQ keys: {}".format(exception))
        sys.exit(exception.code.value)

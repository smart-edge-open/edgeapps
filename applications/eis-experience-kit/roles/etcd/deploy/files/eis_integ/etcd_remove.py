#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

""" ETCD Data Write Tool """
import argparse
import logging
import os
import sys
import eis_integ

def parse_arguments(_cli_args):
    """ Parse argument passed to function """
    parser = argparse.ArgumentParser(description=
                                     "Removing app config from etcd.")
    parser.add_argument("app", help=
                        "Name of the application which config should be removed from etcd.")
    parser.add_argument("--delete_keys", action='store_true',
                        help="Remove all app entries in etcd including ZMQ keys")
    return  parser.parse_args()

def main(args):
    """ Main """
    eis_integ.init_logger()

    os.environ["ETCDCTL_ENDPOINTS"] = "https://" + eis_integ.extract_etcd_endpoint()

    eis_integ.check_path_variable("ETCDCTL_CACERT", os.environ.get("ETCDCTL_CACERT"))
    eis_integ.check_path_variable("ETCDCTL_CERT", os.environ.get("ETCDCTL_CERT"))
    eis_integ.check_path_variable("ETCDCTL_KEY", os.environ.get("ETCDCTL_KEY"))

    print("Remove all {} app related content from etcd database".format(args.app))
    eis_integ.remove_eis_app(args.app, args.delete_keys)
    return eis_integ.CODES.NO_ERROR

if __name__ == '__main__':
    try:
        sys.exit(main(parse_arguments(sys.argv[1:])).value)
    except eis_integ.EisIntegError as exception:
        logging.error("Error while deleting entries from ETCD database: %s", exception)
        sys.exit(exception.code.value)

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
                                     "Adds the contents of the json file to the etcd database.")
    parser.add_argument("arg", help=
                        "Name of the json file whose contents should be added to the database.")
    return  parser.parse_args()

def main(args):
    """ Calls the eis_integ.etcd_put_json function to add the contents of the json file
        to the etcd database """
    eis_integ.init_logger()

    os.environ["ETCDCTL_ENDPOINTS"] = "https://" + eis_integ.extract_etcd_endpoint()

    eis_integ.check_path_variable("ETCDCTL_CACERT", os.environ.get("ETCDCTL_CACERT"))
    eis_integ.check_path_variable("ETCDCTL_CERT", os.environ.get("ETCDCTL_CERT"))
    eis_integ.check_path_variable("ETCDCTL_KEY", os.environ.get("ETCDCTL_KEY"))

    print("Update the etcd database or add {} file contents to the etcd database".format(args.arg))
    eis_integ.etcd_put_json(eis_integ.load_json(args.arg))
    return eis_integ.CODES.NO_ERROR

if __name__ == '__main__':
    try:
        sys.exit(main(parse_arguments(sys.argv[1:])).value)
    except eis_integ.EisIntegError as exception:
        logging.error("Error while adding entries to ETCD database: %s", exception)
        sys.exit(exception.code.value)

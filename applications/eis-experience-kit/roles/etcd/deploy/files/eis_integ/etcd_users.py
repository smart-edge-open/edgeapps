#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

""" ETCD Access Management Tool """
import argparse
import logging
import os
import sys
import traceback
import eis_integ

def parse_arguments(_cli_args):
    """ Parse argument passed to function """
    parser = argparse.ArgumentParser(description="ETCD Access Management Tool"
                                     " - add and remove a new EIS application user to the"
                                     " ETCD database and grant it proper privileges")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-a", "--auth", help="Enable authentication for etcd."
                       " Create root user with root role."
                       " Enter the new password for the root user.")
    group.add_argument("-c", "--create", help="Create etcd user and role for given application."
                       " Enter the application name.")
    group.add_argument("-r", "--remove", help="Remove the given user from the etcd.")
    return parser.parse_args()

def main(args):
    """ Create, remove user or enable authentication for etcd - depending on the input argument """
    eis_integ.init_logger()

    os.environ["ETCDCTL_ENDPOINTS"] = "https://" + eis_integ.extract_etcd_endpoint()

    eis_integ.check_path_variable("ETCDCTL_CACERT", os.environ.get("ETCDCTL_CACERT"))
    eis_integ.check_path_variable("ETCDCTL_CERT", os.environ.get("ETCDCTL_CERT"))
    eis_integ.check_path_variable("ETCDCTL_KEY", os.environ.get("ETCDCTL_KEY"))

    if args.auth:
        print("Enable authentication for etcd. Create root user with root role.")
        eis_integ.enable_etcd_auth(args.auth)
    elif args.create:
        print("Create etcd {} user and role for application.".format(args.create))
        eis_integ.create_etcd_users(args.create)
    elif args.remove:
        print("Remove the {} role and user from the etcd.".format(args.remove))
        eis_integ.remove_user_privilege(args.remove)
        eis_integ.remove_user(args.remove)

    return eis_integ.CODES.NO_ERROR

if __name__ == '__main__':
    try:
        sys.exit(main(parse_arguments(sys.argv[1:])).value)
    except eis_integ.EisIntegError as exception:
        traceback.print_exc(file=sys.stderr)
        sys.exit(exception.code.value)

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

""" EIS integration module """
import enum
import os
import sys
import json
import logging
import argparse
import shlex
import subprocess
import zmq
import zmq.auth

LOGGER_PATH = "/var/log/eis_integ.log"
LOGGER_LEVEL = logging.DEBUG

LOGGER = logging.getLogger(__name__)

CODES = enum.Enum("EisIntegErrorCodes", (
    ("NO_ERROR", 0),
    ("EXT_CMD_ERROR", 1),
    ("CONFIG_ERROR", 2),
    ("FILE_SYSTEM_ERROR", 3)))

class EisIntegError(Exception):
    """Exception to be raised by the `eis_integ` functions"""
    def __init__(self, code):
        super().__init__()
        self.code = code

def check_path_variable(name, path):
    """Throws an exception if the 'path' parameter doesn't represent an existing file
    :param name: Variable name used for helpful error message composition, only
    :param path: Full path to the file
    """
    if path is None:
        logging.error("Variable {0:s} is not set".format(name))
        raise EisIntegError(CODES.CONFIG_ERROR)
    if os.path.isfile(path) is False:
        logging.error("Variable {0:s} doesn't represent an existing file: {1:s}".format(name, path))
        raise EisIntegError(CODES.CONFIG_ERROR)

def load_json(json_path):
    """Read and deserialize specified json data file"""
    try:
        with open(json_path, 'r') as json_file:
            return json.load(json_file)
    except IOError as e:
        logging.error("I/O error occurred during loading of {} json file: {}".format(json_path, e))
        raise EisIntegError(CODES.FILE_SYSTEM_ERROR)


def put_zmqkeys(appname):
    """ Generate public/private key for given app and put it in etcd

    :param appname: App Name
    :type file: String
    """
    pub_key, secret_key = zmq.curve_keypair()

    try:
        etcd_put("/Publickeys/" + appname, pub_key)
    except Exception:
        logging.error("Error putting Etcd public key for {}".format(appname))

    try:
        etcd_put("/" + appname + "/private_key", secret_key)
    except Exception:
        logging.error("Error putting Etcd private key for {}".format(appname))

def enable_etcd_auth(password):
    """ Enable Auth for etcd and Create root user with root role """
    try:
        subprocess.check_output(["etcdctl", "user", "add", "root:"+password], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "role", "add", "root"], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "user", "grant-role", "root", "root"], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "auth", "enable"], stderr=subprocess.STDOUT)
        logging.info("Authentication has been enabled.")
    except subprocess.CalledProcessError as e:
        logging.error("Error while enabling authentication: {}".format(e))
        raise EisIntegError(CODES.EXT_CMD_ERROR)

def etcd_put(key, value):
    """ Add key and value to etcd

    :param key: key will be added to etcd
    :param value: value will be added to etcd
    """
    try:
        subprocess.check_output(["etcdctl", "put", "--", key, value], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        logging.error("Error returned while adding the {} key to the etcd: {}".format(key, e))
        raise EisIntegError(CODES.EXT_CMD_ERROR)


def etcd_put_json(json_data):
    """ Adds the contents of the json file to the etcd database """
    for key, value in json_data.items():
        etcd_put(key, bytes(json.dumps(value, indent=4).encode()))
        logging.info("Value for the {} key has been added to the etcd.".format(key))


def create_etcd_users(appname):
    """ Create etcd user and role for given app. Allow Read only access
     only to appname, global and publickeys directory

    :param appname: App Name
    :type appname: String
    """
    try:
        subprocess.check_output(["etcdctl", "user", "add", appname, "--no-password"], stderr=subprocess.STDOUT)
        logging.info("User {} has been created.".format(appname))
    except subprocess.CalledProcessError as e:
        logging.error("Error while creating {} user: {}".format(appname, e))
        raise EisIntegError(CODES.EXT_CMD_ERROR)

    try:
        subprocess.check_output(["etcdctl", "role", "add", appname], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "user", "grant-role", appname, appname], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "role", "grant-permission", appname, "read", "/"+appname+"/", "--prefix"], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "role", "grant-permission", appname, "readwrite", "/"+appname+"/datastore", "--prefix"], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "role", "grant-permission", appname, "read", "/Publickeys/", "--prefix"], stderr=subprocess.STDOUT)
        subprocess.check_output(["etcdctl", "role", "grant-permission", appname, "read", "/GlobalEnv/", "--prefix"], stderr=subprocess.STDOUT)
        logging.info("Role {} has been created.".format(appname))
    except subprocess.CalledProcessError as e:
        logging.error("Error while creating {} role: {}".format(appname, e))
        raise EisIntegError(CODES.EXT_CMD_ERROR)


def read_config(client):
    """ Read the configuration from etcd.

    :param client: config for specific client
    :type client: String
    """
    logging.info("Read the configuration from etcd")
    subprocess.run(["etcdctl", "get", client, "--prefix"])


def get_etcd_users():
    """ Read all the member info from etcd. """


def grant_user_privilege():
    """ Give access right to the specific user. """

def remove_user_privilege(name):
    """Removes role
    :param name: Rolre name
    :type file: String
    """
    try:
        subprocess.check_output(["etcdctl", "role", "remove", name], stderr=subprocess.STDOUT)
        logging.info("Role {} has been removed.".format(name))
    except subprocess.CalledProcessError as e:
        logging.error("Error returned while removing the {} role: {}".format(name, e))
        raise EisIntegError(CODES.EXT_CMD_ERROR)

def remove_user(name):
    """Removes user
    :param name: User name
    :type file: String
    """
    try:
        subprocess.check_output(["etcdctl", "user", "delete", name], stderr=subprocess.STDOUT)
        logging.info("User {} has been removed.".format(name))
    except subprocess.CalledProcessError as e:
        logging.error("Error returned while removing the {} user: {}".format(name, e))
        raise EisIntegError(CODES.EXT_CMD_ERROR)

def add_user_role():
    """ Add role to the specific user. """


def deploy_eis_app():
    """ Deploy another eis application, e.g. second video stream. """


def remove_eis_application():
    """ Remove existing eis application. """

def remove_eis_key(key):
    """ Remove existing eis key. """
    subprocess.run(["etcdctl", "del", key, "--prefix"])


def init_logger():
    """ Logger initialization """
    logging.basicConfig(level=LOGGER_LEVEL, format='%(levelname)s - %(message)s')
    handler = logging.FileHandler(LOGGER_PATH)
    handler.setLevel(level=logging.DEBUG)
    formatter = logging.Formatter('%(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    LOGGER.addHandler(handler)

def extract_etcd_endpoint():
    """ Extract ETCD service endpoint from Kubernetes """
    jsonpath_ip_string = "jsonpath={.items[?(@.metadata.name==\"ia-etcd-service\")]" + \
        ".spec.clusterIP}"
    jsonpath_port_string = "jsonpath={.items[?(@.metadata.name==\"ia-etcd-service\")]" + \
        ".spec.ports[?(@.name==\"etcd-clt-port\")].port}"

    try:
        etcd_endpoint_ip = subprocess.check_output(["kubectl", "get", "svc", "-n", "eis", "-o",
            jsonpath_ip_string]).decode('utf-8')
        etcd_endpoint_port = subprocess.check_output(["kubectl", "get", "svc", "-n", "eis", "-o",
            jsonpath_port_string]).decode('utf-8')
    except subprocess.CalledProcessError as e:
        logging.error("Failed to call kubectl command to extract ETCD endpoint: '{}'".format(e))
        raise EisIntegError(CODES.EXT_CMD_ERROR)
        
    return etcd_endpoint_ip + ':' + etcd_endpoint_port

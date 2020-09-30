#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

"""This script runs test cases with O-DU and O-RU"""
import logging
import sys
import argparse
import os
from itertools import dropwhile
from datetime import datetime
import json
import socket

N_LTE_NUM_RBS_PER_SYM_F1 = [
    #  5MHz    10MHz   15MHz   20 MHz
    [25, 50, 75, 100]  # LTE Numerology 0 (15KHz)
]

N_NUM_RBS_PER_SYM_F1 = [
    #  5MHz    10MHz   15MHz   20 MHz  25 MHz  30 MHz  40 MHz  50MHz   60 MHz  70 MHz  80 MHz
    # 90 MHz  100 MHz
    [25, 52, 79, 106, 133, 160, 216, 270, 0, 0, 0, 0, 0],         # Numerology 0 (15KHz)
    [11, 24, 38, 51, 65, 78, 106, 133, 162, 0, 217, 245, 273],         # Numerology 1 (30KHz)
    [0, 11, 18, 24, 31, 38, 51, 65, 79, 0, 107, 121, 135]          # Numerology 2 (60KHz)
]

N_NUM_RBS_PER_SYM_F2 = [
    # 50Mhz  100MHz  200MHz   400MHz
    [66, 132, 264, 0],       # Numerology 2 (60KHz)
    [32, 66, 132, 264]      # Numerology 3 (120KHz)
]


N_RCH_BW_OPTIONS_KEYS = ['5', '10', '15', '20', '25', '30', '40', '50', '60', '70', '80', '90',
                         '100', '200', '400']
N_RCH_BW_OPTIONS_VALUES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
N_RCH_BW_OPTIONS = dict(zip(N_RCH_BW_OPTIONS_KEYS, N_RCH_BW_OPTIONS_VALUES))

N_RCH_BW_OPTIONS_KEYS_MU2AND3 = ['50', '100', '200', '400']
N_RCH_BW_OPTIONS_VALUES_MU2AND3 = [0, 1, 2, 3]
N_RCH_BW_OPTIONS_MU2AND3 = dict(zip(N_RCH_BW_OPTIONS_KEYS_MU2AND3, N_RCH_BW_OPTIONS_VALUES_MU2AND3))

DIC_DIR = dict({0:'DL', 1:'UL'})
DIC_XU = dict({0:'o-du', 1:'o-ru'})
DIC_RAN_TECH = dict({0:'5g_nr', 1:'lte'})

def init_logger(console_level, logfile_level):
    """Initializes console and logfile logger with given logging levels"""
    # File logger
    logging.basicConfig(filename="runtests.log",
                        filemode='w',
                        format="%(asctime)s: %(levelname)s: %(message)s",
                        level=logfile_level)
    # Console logger
    logger = logging.getLogger()
    handler = logging.StreamHandler()
    handler.setLevel(console_level)
    formatter = logging.Formatter("%(levelname)s: %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)

def parse_args(args):
    """Configures parser and parses command line configuration"""
    # Parser configuration
    parser = argparse.ArgumentParser(description=
                                     "Run test cases: category numerology bandwidth test_num")

    parser.add_argument("--ran", type=int, default=0, help=
                        "Radio Access Tehcnology 0 (5G NR) or 1 (LTE)",
                        metavar="ran", dest="rantech")
    parser.add_argument("--cat", type=int, default=0, help="Category: 0 (A) or 1 (B)",
                        metavar="cat", dest="category")
    parser.add_argument("--m_u", type=int, default=0, help="numerology [0,1,3]",
                        metavar="num", dest="numerology")
    parser.add_argument("--b_w", type=int, default=20, help="bandwidth [5,10,20,100]",
                        metavar="b_w", dest="bandwidth")
    parser.add_argument("--testcase", type=int, default=0, help="test case number",
                        metavar="testcase", dest="testcase")
    parser.add_argument("--verbose", type=int, default=0, help="enable verbose output",
                        metavar="verbose", dest="verbose")

    # Parse arguments
    options = parser.parse_args(args)
    #parser.print_help()
    logging.debug("Options: ran=%d category=%d num=%d bw=%d testcase=%d",
                  options.rantech, options.category, options.numerology, options.bandwidth,
                  options.testcase)
    return options

def is_comment(line):
    """ function to check if a line
         starts with some character.
         Here # for comment
    """
    # return true if a line starts with #
    return line.startswith('#')

class GetOutOfLoops(Exception):
    """ get out of loops exception """

def get_re_map(nrb, direction):
    """method to get re map"""
    prb_map = []
    prb_elem_content = []
    if direction == 0:
        #DL
        if 'nPrbElemDl' in globals():
            n_prb_elm = 'nPrbElemDl'
            for i in range(0, n_prb_elm):
                elm = str('prb_elem_dl'+str(i))
                #print(elm)
                if elm in globals():
                    prb_elem_content.insert(i, list(globals()[elm]))
                    xrbstart = prb_elem_content[i][0]
                    xrbsize = prb_elem_content[i][1]
                    #print(PrbElemContent,"RBStart: ", xRBStart, "RBSize: ",xRBSize,
                    #list(range(xRBStart, xRBStart + xRBSize)))
                    prb_map = prb_map + list(range(xrbstart*12, xrbstart*12 + xrbsize*12))
        else:
            n_prb_elm = 0

    elif direction == 1:
        #UL
        if 'nPrbElemUl' in globals():
            n_prb_elm = 'nPrbElemUl'
            for i in range(0, n_prb_elm):
                elm = str('prb_elem_ul'+str(i))
                #print(elm)
                if elm in globals():
                    prb_elem_content.insert(i, list(globals()[elm]))
                    xrbstart = prb_elem_content[i][0]
                    xrbsize = prb_elem_content[i][1]
                    #print(PrbElemContent,"RBStart: ", xRBStart, "RBSize: ",xRBSize,
                    #list(range(xRBStart, xRBStart + xRBSize)))
                    prb_map = prb_map + list(range(xrbstart*12, xrbstart*12 + xrbsize*12))
        else:
            n_prb_elm = 0

    if n_prb_elm == 0:
        prb_map = list(range(0, nrb*12))

    return prb_map

def compare_results(rantech, cat, m_u, xran_path, direction, context):
    """method to compare results"""
    res = 0
    re_map = []
    if rantech == 1:
        if m_u == 0:
            n_dirb = N_NUM_RBS_PER_SYM_F1[m_u][N_RCH_BW_OPTIONS.get(str(context["nDLBandwidth"]))]
            n_uirb = N_NUM_RBS_PER_SYM_F1[m_u][N_RCH_BW_OPTIONS.get(str(context["nULBandwidth"]))]
        else:
            print("Incorrect arguments\n")
            res = -1
            return res
    elif rantech == 0:
        if m_u < 3:
            n_dirb = N_NUM_RBS_PER_SYM_F1[m_u][N_RCH_BW_OPTIONS.get(str(context["nDLBandwidth"]))]
            n_uirb = N_NUM_RBS_PER_SYM_F1[m_u][N_RCH_BW_OPTIONS.get(str(context["nULBandwidth"]))]
        elif (m_u >= 2) & (m_u <= 3):
            n_dirb = N_NUM_RBS_PER_SYM_F2[m_u - 2][N_RCH_BW_OPTIONS_MU2AND3.get(
                                str(context["nDLBandwidth"]))]
            n_uirb = N_NUM_RBS_PER_SYM_F2[m_u - 2][N_RCH_BW_OPTIONS_MU2AND3.get(
                                str(context["nULBandwidth"]))]
            print(n_dirb, n_uirb)
        else:
            print("Incorrect arguments\n")
            res = -1
            return res

    if "compression" in context:
        comp = 'compression'
    else:
        comp = 0

    print("compare results: {} [compression {}]\n".format(DIC_DIR.get(direction), comp))

    #if cat == 1:
    #    print("WARNING: Skip checking IQs and BF Weights for CAT B for now\n");
    #    return res

    #get slot config
    if context["nFrameDuplexType"] == 1:
        slot_config = []
        for i in range(context["nTddPeriod"]):
            if i == 0:
                slot_config.insert(i, context["sslot_config0"])
            elif i == 1:
                slot_config.insert(i, context["sslot_config1"])
            elif i == 2:
                slot_config.insert(i, context["sslot_config2"])
            elif i == 3:
                slot_config.insert(i, context["sslot_config3"])
            elif i == 4:
                slot_config.insert(i, context["sslot_config4"])
            elif i == 5:
                slot_config.insert(i, context["sslot_config5"])
            elif i == 6:
                slot_config.insert(i, context["sslot_config6"])
            elif i == 7:
                slot_config.insert(i, context["sslot_config7"])
            elif i == 8:
                slot_config.insert(i, context["sslot_config8"])
            elif i == 9:
                slot_config.insert(i, context["sslot_config9"])
            else:
                raise Exception('i should not exceed nTddPeriod %d. The value of i was: {}'
                                .format(context["nTddPeriod"], i))
        #print(SlotConfig, type(sSlotConfig0))
    try:

        if (direction == 1) & (cat == 1): #UL
            flow_id = context["ccNum"]*context["antNumUL"]
        else:
            flow_id = context["ccNum"]*context["antNum"]

        if direction == 0:
            re_map = get_re_map(n_dirb, direction)
        elif direction == 1:
            re_map = get_re_map(n_uirb, direction)
        else:
            raise Exception('Direction is not supported %d'.format(direction))

        for i in range(0, flow_id):
            #read ref and test files
            tst = []
            ref = []
            if direction == 0:
                # DL
                nrb = n_dirb
                file_tst = xran_path+"/results/"+"o-ru-rx_log_ant"+str(i)+".txt"
                file_ref = xran_path+"/results/"+"o-du-play_ant"+str(i)+".txt"
#                file_tst = xran_path+"/app/logs/"+"o-ru-rx_log_ant"+str(i)+".txt"
#                file_ref = xran_path+"/app/logs/"+"o-du-play_ant"+str(i)+".txt"

            elif direction == 1:
                # UL
                nrb = n_uirb
                file_tst = xran_path+"/results/"+"o-du-rx_log_ant"+str(i)+".txt"
                file_ref = xran_path+"/results/"+"o-ru-play_ant"+str(i)+".txt"
#                file_tst = xran_path+"/app/logs/"+"o-du-rx_log_ant"+str(i)+".txt"
#                file_ref = xran_path+"/app/logs/"+"o-ru-play_ant"+str(i)+".txt"
            else:
                raise Exception('Direction is not supported %d'.format(direction))

            print("test result   :", file_tst)
            print("test reference:", file_ref)
            if os.path.exists(file_tst):
                try:
                    file_tst = open(file_tst, 'r')
                except OSError:
                    print("Could not open/read file:", file_tst)
                    sys.exit()
            else:
                print(file_tst, "doesn't exist")
                res = -1
                return res
            if os.path.exists(file_ref):
                try:
                    file_ref = open(file_ref, 'r')
                except OSError:
                    print("Could not open/read file:", file_ref)
                    sys.exit()
            else:
                print(file_tst, "doesn't exist")
                res = -1
                return res

            tst = file_tst.readlines()
            ref = file_ref.readlines()

            print(len(tst))
            print(len(ref))

            file_tst.close()
            file_ref.close()

            print(context["numSlots"])

            for slot_idx in range(0, context["numSlots"]):
                for sym_idx in range(0, 14):
                    if context["nFrameDuplexType"] == 1:
                        #skip sym if TDD
                        if direction == 0:
                            #DL
                            sym_dir = slot_config[slot_idx%context["nTddPeriod"]][sym_idx]
                            if sym_dir != 0:
                                continue
                        elif direction == 1:
                            #UL
                            sym_dir = slot_config[slot_idx%context["nTddPeriod"]][sym_idx]
                            if sym_dir != 1:
                                continue

                    #print("Check:","[",i,"]", slot_idx, sym_idx)
                    for line_idx in re_map:
                        offset = (slot_idx*nrb*12*14) + sym_idx*nrb*12 + line_idx
                        try:
                            line_tst = tst[offset].rstrip()
                        except IndexError:
                            res = -1
                            print("FAIL:", "IndexError on tst: ant:[", i, "]:",
                                  offset, slot_idx, sym_idx, line_idx, len(tst))
                            raise GetOutOfLoops
                        try:
                            line_ref = ref[offset].rstrip()
                        except IndexError:
                            res = -1
                            print("FAIL:", "IndexError on ref: ant:[", i, "]:",
                                  offset, slot_idx, sym_idx, line_idx, len(ref))
                            raise GetOutOfLoops

                        if comp == 1:
                            # discard LSB bits as BFP compression is not "bit exact"
                            tst_i_value = int(line_tst.split(" ")[0]) & 0xFF80
                            tst_q_value = int(line_tst.split(" ")[1]) & 0xFF80
                            ref_i_value = int(line_ref.split(" ")[0]) & 0xFF80
                            ref_q_value = int(line_ref.split(" ")[1]) & 0xFF80

                            #print("check:","ant:[",i,"]:",offset, slot_idx, sym_idx,
                            #line_idx,":","tst: ",tst_i_value, " ", tst_q_value, " " ,
                            # "ref: ", ref_i_value, " ", ref_q_value, " ")
                            if (tst_i_value != ref_i_value) or  (tst_q_value != ref_q_value):
                                print("FAIL:", "ant:[", i, "]:", offset, slot_idx, sym_idx,
                                      line_idx, ":", "tst: ", tst_i_value, " ", tst_q_value, " ",
                                      "ref: ", ref_i_value, " ", ref_q_value, " ")
                                res = -1
                                raise GetOutOfLoops
                        else:
                            #if line_idx == 0:
                                #print("Check:", offset,"[",i,"]", slot_idx, sym_idx,":",
                                #line_tst, line_ref)
                            if line_ref != line_tst:
                                print("FAIL:", "ant:[", i, "]:", offset, slot_idx, sym_idx,
                                      line_idx, ":", "tst:", line_tst, "ref:", line_ref)
                                res = -1
                                raise GetOutOfLoops
    except GetOutOfLoops:
        return res

    #if (direction == 0) | (cat == 0) | (srs_enb == 0): #DL or Cat A
        #done
    return res

def parse_dat_file(test_cfg):
    """parse config files"""
    logging.info("parse config files %s\n", test_cfg[0])
    line_list = list()
    sep = '#'
    with open(test_cfg[0], 'r') as f_h:
        for curline in dropwhile(is_comment, f_h):
            my_line = curline.rstrip().split(sep, 1)[0].strip()
            if my_line:
                line_list.append(my_line)
    global_env = {}
    local_env = {}

    for line in line_list:
        exe_line = line.replace(":", ",")
        if exe_line.find("/") > 0:
            exe_line = exe_line.replace('./', "'")
            exe_line = exe_line+"'"

        code = compile(str(exe_line), '<string>', 'exec')
        exec(code, global_env, local_env)

    return local_env

def run_tcase(rantech, cat, m_u, b_w, tcase, xran_path):
    """ method for runing test cases"""
    if rantech == 1: #LTE
        if cat == 1:
            test_config = xran_path+"/app/usecase/lte_b/mu{0:d}_{1:d}mhz".format(m_u, b_w)
        elif cat == 0:
            test_config = xran_path+"/app/usecase/lte_a/mu{0:d}_{1:d}mhz".format(m_u, b_w)
        else:
            print("Incorrect cat arguments\n")
            return -1
    elif rantech == 0: #5G NR
        if cat == 1:
            test_config = xran_path+"/app/usecase/cat_b/mu{0:d}_{1:d}mhz".format(m_u, b_w)
        elif cat == 0:
            test_config = xran_path+"/app/usecase/mu{0:d}_{1:d}mhz".format(m_u, b_w)
        else:
            print("Incorrect cat argument\n")
            return -1
    else:
        print("Incorrect rantech argument\n")
        return -1

    if tcase > 0:
        test_config = test_config+"/"+str(tcase)

    test_cfg = []

    test_cfg.append(test_config+"/config_file_o_du.dat")
    test_cfg.append(test_config+"/config_file_o_ru.dat")

    w_d = os.getcwd()
    os.chdir(xran_path+"/app/")

#    make_copy_mlog(rantech, cat, mu, bw, tcase, xran_path)

    usecase_cfg = parse_dat_file(test_cfg)

    res = compare_results(rantech, cat, m_u, xran_path, 0, usecase_cfg)
    if res != 0:
        os.chdir(w_d)
        print("FAIL")
        return res

    res = compare_results(rantech, cat, m_u, xran_path, 1, usecase_cfg)
    if res != 0:
        os.chdir(w_d)
        print("FAIL")
        return res

    os.chdir(w_d)
    print("PASS")

    return res

def main():
    """Processes input files to produce IACA files"""
    test_results = []
    all_test_cases = []
    run_total = 0
    cat = 0
    m_u = 0
    b_w = 0
    tcase = 0
    # Find path to XRAN
    if os.getenv("XRAN_DIR") is not None:
        xran_path = os.getenv("XRAN_DIR")
    else:
        print("please set 'export XRAN_DIR' in the OS")
        return -1

    # Set up logging with given level (DEBUG, INFO, ERROR) for console end logfile
    init_logger(logging.INFO, logging.DEBUG)
    host_name = socket.gethostname()
    logging.info("host: %s Started testverification script: master.py from XRAN path %s"
                 , host_name, xran_path)

    options = parse_args(sys.argv[1:])
    rantech = options.rantech
    cat = options.category
    m_u = options.numerology
    b_w = options.bandwidth
    tcase = options.testcase
    #verbose = options.verbose


    if run_total:
        for test_run_ix in range(0, run_total):
            rantech = all_test_cases[test_run_ix][0]
            cat = all_test_cases[test_run_ix][1]
            m_u = all_test_cases[test_run_ix][2]
            b_w = all_test_cases[test_run_ix][3]
            tcase = all_test_cases[test_run_ix][4]
            #verbose = 0

            logging.info("Test# %d out of %d: ran %d cat %d m_u %d b_w %d test case %d\n",
                         test_run_ix, run_total, rantech, cat, m_u, b_w, tcase)
            res = run_tcase(rantech, cat, m_u, b_w, tcase, xran_path)
            if res != 0:
                test_results.append((rantech, cat, m_u, b_w, tcase, 'FAIL'))
                continue

            test_results.append((rantech, cat, m_u, b_w, tcase, 'PASS'))

            with open('testresult.txt', 'w') as reshandle:
                json.dump(test_results, reshandle)
    else:
        res = run_tcase(rantech, cat, m_u, b_w, tcase, xran_path)
        if res != 0:
            test_results.append((rantech, cat, m_u, b_w, tcase, 'FAIL'))
        test_results.append((rantech, cat, m_u, b_w, tcase, 'PASS'))

        with open('testresult.txt', 'w') as reshandle:
            json.dump(test_results, reshandle)

    return res

if __name__ == '__main__':
    START_TIME = datetime.now()
    RES = main()
    END_TIME = datetime.now()
    logging.debug("Start time: %s, end time: %s", START_TIME, END_TIME)
    logging.info("Execution time: %s", END_TIME - START_TIME)
    logging.shutdown()
    sys.exit(RES)

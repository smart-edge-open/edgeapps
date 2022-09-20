#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation


DEF_APP_MODE=$XRAN_DEF_APP_MODE
DEF_TECH=$XRAN_DEF_TECH
DEF_CAT=$XRAN_DEF_CAT
DEF_MU=$XRAN_DEF_MU
DEF_BW=$XRAN_DEF_BW
DEF_TC=$XRAN_DEF_TC
TEST_VERBOSE=1
CONFIG_FILE_DU="config_file_o_du.dat"
CONFIG_FILE_RU="config_file_o_ru.dat"

RESULTS_DIR="/opt/flexran_xran/results/"

APP_BIN="./build/sample-app"

declare -a ethUpDev
declare -a ethCpDev

printEnv()
{
  echo -e "\tXRAN_DIR=$XRAN_DIR"
  echo -e "\tRTE_SDK=$RTE_SDK"
  echo -e "\tRTE_TARGET=$RTE_TARGET"

}

printHelp()
{
  echo ""
  echo "Usage: $0 -a appMode -t testCaseNum -m mu -b bw -p portNum -i "du_up_port1 du_cp_port2 ru_up_port1 ru_cp_port2""
  echo -e "\t-a application mode: ru, du , ru-du, none"
  echo -e "\t-t ran technology type ( 0 for 5G, 1 for LTE )"
  echo -e "\t-c category ( 0 or 1 )"
  echo -e "\t-n test case number"
  echo -e "\t-m mu ( mu MIMO )"
  echo -e "\t-b bandwidth"
  echo -e "\t-p number of ports provided"
  echo -e "\t-i phisical addresses of ports to be used in testing example: "0000:86:00.1 0000:86:00.2""
  exit 1

}

printArgs()
{
  echo -e "\tappMode=$mode"
  echo -e "\ttech=$tech ( 0 for 5G, 1 for LTE )"
  echo -e "\tcat=$cat"
  echo -e "\ttc=$tc"
  echo -e "\tmu=$mu"
  echo -e "\tbw=$bw"
  echo -e "\tportsNum=$portNum"
  echo -e "\tport_up_du=${ethUpDev[0]}"
  echo -e "\tport_cp_du=${ethCpDev[0]}"
  echo -e "\tport_up_ru=${ethUpDev[1]}"
  echo -e "\tport_cp_ru=${ethCpDev[1]}"

}

checkMode()
{
   reqPortNum=0
   case $mode in
    "ru-du" )
       reqPortNum=4 ;;
    "ru" )
       reqPortNum=2 ;;
    "du" )
       reqPortNum=2 ;;
    "none" )
       echo -e "\tExiting application started with mode: $mode"
       exit 0 ;;
    * )
      echo -e "\tWrong application mode: $mode"
      printHelp
      exit 1 ;;
  esac

  if [[ -z "$portNum" ]]; then
    portNum=$reqPortNum
  elif [[ $portNum -ne $reqPortNum ]]; then
    echo "Number of ports is set to "$portNum ". Application requires $reqPortNum ports."
    exit 1
  fi

}

setEnvPorts()
{
  IFS=$'\n' read -r -d '' -a vfs < <( lspci | grep "Virtual Function" | awk '{ print $1}' && printf '\0' )
  if [[ ${#vfs[@]} -lt $portNum ]]; then
    echo -e "\tFound ${#vfs[@]} virtual ports available, required $portNum"
    exit 1
  fi

  case $mode in
    "ru-du" )
      DEF_DU_P1="0000:"${vfs[0]}
      DEF_DU_P2="0000:"${vfs[1]}
      DEF_RU_P1="0000:"${vfs[2]}
      DEF_RU_P2="0000:"${vfs[3]}
      ;;
    "du" )
      DEF_DU_P1="0000:"${vfs[0]}
      DEF_DU_P2="0000:"${vfs[1]}
      ;;
    "ru" )
      DEF_RU_P1="0000:"${vfs[2]}
      DEF_RU_P2="0000:"${vfs[3]}
      ;;
  esac

}

procModeReq()
{

  case $mode in
    "ru-du" )
      if [ -z "$p1" ]; then
        p1=$DEF_DU_P1
        echo "SETTING P1: $p1"
      fi
      if [ -z "$p2" ]; then
        p2=$DEF_DU_P2
      fi

      if [ -z "$p3" ]; then
        p3=$DEF_RU_P1
      fi
      if [ -z "$p4" ]; then
        p4=$DEF_RU_P2
      fi

      ethUpDev[0]=$p1
      ethCpDev[0]=$p2
      ethUpDev[1]=$p3
      ethCpDev[1]=$p4
      ;;
    "ru" )
      if [ -z "$p3" ]; then
        p3=$DEF_RU_P1
      fi
      if [ -z "$p4" ]; then
        p4=$DEF_RU_P2
      fi
      ethUpDev[1]=$p3
      ethCpDev[1]=$p4
      ;;
    "du" )
      if [ -z "$p1" ]; then
        p1=$DEF_DU_P1
      fi
      if [ -z "$p2" ]; then
        p2=$DEF_DU_P2
      fi
      ethUpDev[0]=$p1
      ethCpDev[0]=$p2
      ;;
  esac
}

runTestScripts()
{
  pids=""
  scripts="$1"
  len=${#scripts[@]}

  for ((i=1; i<len+1; i++))
  do
    "./${scripts[$i-1]}" > "test_output$i.txt" 2>&1 &
    pids+="$! "
  done

  p=0
  for pid in $pids; do
    if wait "$pid"; then
      echo -e "\tProcess $pid running ${scripts[$p]} exited with a status $?"
    else
      echo -e "\tProcess $pid running ${scripts[$p]} failed with a status $?"
    fi
    ((p++))
  done
}

run()
{
  pids=""
  scripts="$1"
  len=${#scripts[@]}
  cmd="./usecase/"

  if [ "$tech" -eq 1 ]; then
    if [ "$cat" -eq 1 ]; then
      cmd="${cmd}lte_b/mu${mu}_${bw}mhz/"
    elif [ "$cat" -eq 0 ]; then
      cmd="${cmd}lte_a/mu${mu}_${bw}mhz/"
    else
      echo "Wrong cat argument"
      exit 1
    fi
  elif [ "$tech" -eq 0 ]; then
    if [ "$cat" -eq 1 ]; then
      echo "cat = $cat"
      cmd="${cmd}cat_b/mu${mu}_${bw}mhz/"
    elif [ "$cat" -eq 0 ]; then
      cmd="${cmd}mu${mu}_${bw}mhz/"
    else
      echo "Wrong cat argument"
      exit 1
    fi
  fi

  if [ "$tc" -gt 0 ]; then
    cmd=$cmd$tc"/"
  fi

  for ((i=1; i<len+1; i++))
  do
    portIndex=$i
    if [[ -z ${ethUpDev[portIndex-1]} ]] && [[ -z ${ethUpDev[portIndex-1]} ]]; then
      (( portIndex++ ))
    fi
    testCmd="$APP_BIN -c $cmd${scripts[$i-1]} -p 2 ${ethUpDev[portIndex-1]} ${ethCpDev[portIndex-1]}"
    echo -e "\t$testCmd"
    outFile=$XRAN_DIR"/app/logs/test_output_"
    outFile=$outFile${scripts[$i-1]:14:2}".txt"
    echo -e "\tWriting application output to $outFile"
    $testCmd > "$outFile" 2>&1 &
    pids+="$! "
  done

  p=0
  for pid in $pids; do
    if wait "$pid"; then
      echo -e "\tProcess $pid running ${scripts[$p]} exited with a status $?"
    else
      echo -e "\tProcess $pid running ${scripts[$p]} failed with a status $?"
    fi
    ((p++))
  done
}

testDuRu()
{
  scripts=( "$CONFIG_FILE_DU" "$CONFIG_FILE_RU" )
  cd "$XRAN_DIR/app" || exit 1
  run "${scripts[0]}"
}

testDu()
{
  scripts=( "$CONFIG_FILE_DU" )
  run "${scripts[0]}"
}

testRu()
{
  scripts=( "$CONFIG_FILE_RU" )
  run "${scripts[0]}"
}

verifyTests()
{
  if [[ "$mode" = "ru" ]] || [[ "$mode" = "ru-du" ]]; then
    if ! rm -f $RESULTS_DIR/o-ru-play_*; then
      echo "Error while removing RU files"
      exit 1
    fi
    if ! cp "$XRAN_DIR"/app/logs/o-ru-* $RESULTS_DIR; then
      echo "Error while coping RU files"
      exit 1
    fi
  fi
  if [[ "$mode" = "du" ]] || [[ "$mode" = "ru-du" ]]; then
    if ! rm -f $RESULTS_DIR/o-du-*; then
      echo "Error while removing DU files"
      exit 1
    fi
    if ! cp "$XRAN_DIR"/app/logs/o-du-* $RESULTS_DIR; then
      echo "Error while coping DU files"
      exit 1
     fi
  fi
  if [[ "$mode" = "ru" ]]; then
    echo -e "\t$(date) RU test completed"
    return
  fi

  cd "$XRAN_DIR/app" || exit 1

  echo "STEP 2: VERIFY TESTS RESULTS"

  python "$XRAN_DIR/app/test_verification.py" --ran "$tech" --cat "$cat" --testcase "$tc" --m_u "$mu"  --b "$bw" --verbose "$TEST_VERBOSE"
  echo -e "\t$(date) xRAN sample app test and test verification completed"

}

echo TEST CONFIGURATION:

#CHECKING ENVIRONMENT VARIABLES


if [ -z "$XRAN_DIR" ] || [ -z "$RTE_SDK"  ] || [ -z "$RTE_TARGET" ]
then
  echo -e "\tEnvironment variables are not set"
  printEnv
  exit 1
fi

printEnv

#COLLECTING ARGUMENTS

while getopts "a:t:c:m:b:n:p:i:" opt
do
  case "$opt" in
    a ) mode="$OPTARG" ;;
    t ) tech="$OPTARG" ;;
    c ) cat="$OPTARG" ;;
    m ) mu="$OPTARG" ;;
    b ) bw="$OPTARG" ;;
    n ) tc="$OPTARG" ;;
    p ) portNum="$OPTARG" ;;
    i )
      read -ra ports <<< "$OPTARG"
      if [[ ${#ports[*]} -ne $portNum ]]; then
        echo -e "\t Received  ${#ports[*]} port(s), while awaiting $portNum"
      fi
      p1=${ports[0]}
      p2=${ports[1]}
      p3=${ports[2]}
      p4=${ports[3]}
      ;;
    ? ) printHelp ;;
  esac
done

[ -z "$mode" ] && mode=$DEF_APP_MODE
[ -z "$tech" ] && tech=$DEF_TECH
[ -z "$cat" ] && cat=$DEF_CAT
[ -z "$mu" ] && mu=$DEF_MU
[ -z "$bw" ] && bw=$DEF_BW
[ -z "$tc" ] && tc=$DEF_TC


#CHECKING APPLICATION MODE AND PORTS NUMBER"

checkMode

setEnvPorts

procModeReq

printArgs

#TEST

echo "STEP 1: RUN TESTS"

cd "$XRAN_DIR/app" || exit 1
case $mode in
  "ru-du" )
    echo -e "\t$(date) Starting RU and DU"
    testDuRu ;;
  "ru" )
    echo -e "\t$(date) Starting RU"
    testRu ;;
  "du" )
    echo -e "\t$(date) Starting DU"
    testDu ;;
esac

#VERIFY TESTS RESULTS"
verifyTests

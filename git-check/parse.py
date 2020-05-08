#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright (C) 2020 Kazuhiko Kamikado <kamikado3@gmail.com>

import subprocess
import sys
import re


def check_code(code):
    lines = code.split("\n")
    change_numbers = []
    changed_lines = []
    num = 0
    for line in lines:
        if len(line) == 0:
            num += 1
            continue
        if line[0] == " " or line[0] == "+":
            num += 1
        if line[0] == "+" or line[0] == "-":
            change_numbers += [num]
            changed_lines += [line]
    return change_numbers, changed_lines


def check_hash_for_compile_mode(hash):
    command = "git diff " + hash + " -U1000000"
    lines = subprocess.getoutput(command)
    separator = "diff " + "--git"
    lines = re.split(separator, lines)
    print()
    print("<Files changed>")
    for line in lines[1:]:
        file_name = line.split("\n")[0].split(" ")[-1]
        file_name = subprocess.getoutput(
            "git rev-parse --show-toplevel") + "/" + "/".join(file_name.split("/")[1:])
        print("File: " + file_name)
    print()
    print("<Details>")
    for line in lines[1:]:
        file_name = line.split("\n")[0].split(" ")[-1]
        file_name = subprocess.getoutput(
            "git rev-parse --show-toplevel") + "/" + "/".join(file_name.split("/")[1:])
        code = line.split("@@\n")[-1]
        indexs, lines = check_code(code)
        print("File: " + file_name)
        for num, line in zip(indexs, lines):
            path = str(num) + ":1:"
            output = " " + line[0]+path+line[1:]
            print(output)


def output_for_compile_mode():
    num = 1
    if len(sys.argv) > 1:
        num = int(sys.argv[1])
    command = 'git log -n ' + \
        str(num+1) + ' --pretty=format:"\'%s\' [%an] [%ad]"'
    hashes = subprocess.getoutput(command).split("\n")
    print("<Commit history>")
    print(0, "not commited")
    for index, hash in enumerate(hashes[:num-1]):
        print(index+1, hash)
    print("after:", hashes[num-1])

    command = 'git log -n ' + str(num+1) + ' --pretty=format:"%H"'
    hashes = subprocess.getoutput(command).split("\n")
    for index, hash in enumerate(hashes[num-1:num]):
        check_hash_for_compile_mode(hash)


def check_hash_for_helm_mode(hash):
    command = "git diff " + hash + " -U1000000"
    lines = subprocess.getoutput(command)
    separator = "diff " + "--git"
    lines = re.split(separator, lines)
    for line in lines[1:]:
        file_name = line.split("\n")[0].split(" ")[-1]
        file_name = subprocess.getoutput(
            "git rev-parse --show-toplevel") + "/" + "/".join(file_name.split("/")[1:])
        code = line.split("@@\n")[-1]
        indexs, lines = check_code(code)
        for num, line in zip(indexs, lines):
            path = file_name + ":" + str(num) + ":1:"
            print(path, line)


def output_for_helm_mode():
    num = 1
    command = 'git log -n ' + str(num+1) + ' --pretty=format:"%H"'
    hashes = subprocess.getoutput(command).split("\n")
    for index, hash in enumerate(hashes[num-1:num]):
        check_hash_for_helm_mode(hash)


def main():
    if "".join(sys.argv[1:]).find("for_helm") != -1:
        output_for_helm_mode()
    else:
        output_for_compile_mode()


if __name__ == '__main__':
    main()

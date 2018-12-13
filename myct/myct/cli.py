import argparse
import shutil
import os
from myct.utils import split_key_value


class CLI:

    dependencies = {
        # 'executable':'package',
        'debootstrap':'debootstrap',
        'chroot':'chroot',
        'unshare':'unshare',
        'nsenter':'nsenter',
        'cgexec':'cgroup-tools'
    }

    def __init__(self):
        """
        TODO color output (needs additional python package)
        """
        for exec,pkg in self.dependencies.items():
            if not shutil.which(exec):
                print('Install ' + pkg)
                os.system('sudo apt -y install ' + pkg)

    def run(self):
        """
        Parse arguments and start selected command
        """
        parser = argparse.ArgumentParser(description="Create and control containers with the 'My Container Tool'.")
        subparsers = parser.add_subparsers(title='myct commands',
                                           # dest='command',
                                           metavar='COMMAND',
                                           help='Use COMMAND -h to get help for each command.')
        subparsers.required = True

        parser_init = subparsers.add_parser('init', help='Creates a container in the given directory')
        parser_init.add_argument('path', metavar='<container-path>')
        parser_init.set_defaults(func=self._init_command)

        parser_map = subparsers.add_parser('map',
                                            help='Mounts a host directory read-only into the container at given target')
        parser_map.add_argument('cpath', metavar='<container-path>')
        parser_map.add_argument('hpath', metavar='<host-path>')
        parser_map.add_argument('tpath', metavar='<target-path>')
        parser_map.set_defaults(func=self._map_command)

        parser_run = subparsers.add_parser('run', help='Runs the file exectuable in container with passed arguments')
        parser_run.add_argument('path', metavar='<container-path>')
        parser_run.add_argument('exec', metavar='<executable>')
        parser_run.add_argument('exec_args', metavar='args', nargs='*')
        parser_run.add_argument('--namespace', type=split_key_value, metavar='<kind>=<pid>', help='Join a namespace.')  # With 'type=' we could achieve automated splitting
        parser_run.add_argument('--limit', action='append', type=split_key_value, metavar='<controller.key>=<value>', help='Define limits. May repeat')  # With 'type=' we could achieve automated splitting
        parser_run.set_defaults(func=self._run_command)

        args, unknown = parser.parse_known_args()
        args.func(args, unknown)

    def _init_command(self, args, unknown):
        """
        Creates a container in the given directory (downloads and extracts root file system)
        $ myct init <container-path>

        TODO Possible additional arguments: mirror and suite (currently 'stable')
        """
        if unknown:
            raise argparse.ArgumentTypeError("Detected unknown arguments: {!s}".format(str(unknown)))
        print("Command init with path: " + str(args.path))
        os.system('sudo debootstrap --no-merged-usr stable ' + args.path)

    def _map_command(self, args, unknown):
        """
        Mounts a host directory read-only into the container at given destination
        $ myct map <container-path> <host-path> <target-path>
        """
        if unknown:
            raise argparse.ArgumentTypeError("Detected unknown arguments: {!s}".format(str(unknown)))
        print("Command map with container {}, host path {} and target {}.".format(args.cpath, args.hpath, args.tpath))

    def _run_command(self, args, unknown):
        """
        Runs the file exectuable in container with passed arguments
        $ myct run <container-path> [options] <executable> [args...]
        with options being:
        --namespace <kind>=<pid>
        --limit <controller.key>=<value>
        """
        args.exec_args += unknown
        print("Command run with container {} and the executable {} with arguments {}.\nJoin namespace {} and set limits {}".format(
            args.path, args.exec, args.exec_args, args.namespace, args.limit))
        # TODO FIX apt won't work as it seem to recognize the false root -> https://unix.stackexchange.com/questions/487870/filesystem-permission-problems-with-user-namespaces-and-debootstrap
        #      QUICKFIX remove the flags --user and --map-root-user. This means the commands need sudo.
        # TODO the unshare command is right now ultra restrictive. We probably need to drop some stuff like --net and --uts
        setup_commands_head = [
            'unshare --mount --uts --ipc --net --fork --user --map-root-user',
            'chroot ' + args.path,
            'unshare --pid --fork /bin/bash -c'
            ]

        setup_commands_tail = [
            'mount -t proc none /proc',
            'mount -t sysfs none /sys',
            'mount -t tmpfs none /tmp',
            args.exec + ' ' + ' '.join(args.exec_args)
        ]

        setup_commands_head.append("'" + ' && '.join(setup_commands_tail) + "'")

        os.system(' '.join(setup_commands_head))


def run():
    if os.name == 'nt':
        raise NotImplementedError("Not implemented for Windows.")
    CLI().run()

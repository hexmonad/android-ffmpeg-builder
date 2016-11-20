#
# For the full copyright and license information, please view the LICENSE file that was distributed
# with this source code. (c) 2016
# 
# Created by Sergey Chernenok on 27.08.2016
#

from argparse import ArgumentParser
from tempfile import mkstemp
from shutil import move
from os import remove, close, getcwd

# This cause ffmpeg shared libraries to be compiled to <libname>-<version>.so.
def changeGeneratedSoNames(file_path):
    # Create temp file
    fh, abs_path = mkstemp()
    with open(abs_path,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                if line.startswith("SLIBNAME_WITH_VERSION='"):
                    new_file.write("SLIBNAME_WITH_VERSION='$(SLIBNAME)'\n")
                elif line.startswith("SLIBNAME_WITH_MAJOR='"):
                    new_file.write("SLIBNAME_WITH_MAJOR='$(SLIBNAME)'\n")
                elif line.startswith("SLIB_INSTALL_NAME='"):
                    new_file.write("SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'\n")
                elif line.startswith("SLIB_INSTALL_LINKS='"):
                    new_file.write("SLIB_INSTALL_LINKS=\n")
                else:
                    new_file.write(line)
    close(fh)
    # Remove original file
    remove(file_path)
    # Move new file
    move(abs_path, file_path)


parser = ArgumentParser()
parser.add_argument("-i", "--input", dest="dir",
                    help="Directory where a ffmpeg configure file is located (default is \"FFmpeg\")",
                    default="FFmpeg")

args = parser.parse_args()

input_dir = args.dir
if input_dir is None:
    input_dir = getcwd()
elif input_dir[-1] != '/':
    input_dir += '/'

configureFile = input_dir + "configure"

print "Updating FFmpeg configure file ...",
changeGeneratedSoNames(configureFile)
print "Done"

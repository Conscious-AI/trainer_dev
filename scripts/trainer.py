import os
import sys
import time as t


SCRIPTS_DIR = ["../audio_processing/", "../command_recognizer/"]
"""
SCRIPTS = ['dynamic_threshold.py',
           'record_save.py',
           'train.py',
           'test.py',
           'recognize_command.py']
"""

for i in range(len(SCRIPTS_DIR)):
    sys.path.append(SCRIPTS_DIR[i])


def printout(p):
    print(f"CAI: TRAINER: {p}", file=sys.stdout)
    sys.stdout.flush()


printout("H1: Calibrating Microphone Threshold...Don't make any noise !")
t.sleep(2)

for i in reversed(range(5)):
    printout(f"H2: Calibration starting in {i+1}...")
    t.sleep(1)

printout("H1: Calibration Running for 10 seconds...")
t.sleep(0.5)
printout(
    "H2: - Don't speak anything or make any noise.\n- Let the subtle noise of your surroundings be captured by the mic."
)
os.chdir(SCRIPTS_DIR[0])
import dynamic_threshold

printout("H1: Calibration Complete !")
t.sleep(2)

printout("H1: Recording commands as you speak...")
t.sleep(0.5)
printout(
    "H2: - Position yourself within the reasonable distance from your mic.\n- Speak clearly and loudly without mistake."
)
t.sleep(5)

printout("H1: Recorder starting...")
os.chdir(SCRIPTS_DIR[1])
import record_save

printout("H1: Recording complete !")
t.sleep(2)

# TODO: Denoising without elevation
# printout('H1: Populating command dataset by denoising audio files...')
# os.chdir(SCRIPTS_DIR[0])
# import denoiser

printout("H1: Dataset is ready for training !")
t.sleep(2)

printout("H1: Training command model...This may take a while...")
t.sleep(2)

for i in reversed(range(5)):
    printout(f"H2: Training commencing in {i+1}...")
    t.sleep(1)

printout("H2: ")
os.chdir(SCRIPTS_DIR[1])
import train

printout("H1: Training complete !")
t.sleep(2)

printout("H1: Now lets do some validation before proceeding...")
t.sleep(2)

for i in reversed(range(5)):
    printout(f"H2: Validator starting in {i+1}...")
    t.sleep(1)

printout("H1: Speak the commands below when 'Now Listening...' is displayed")

os.chdir(SCRIPTS_DIR[1])
from recognize_command import CommandRecognizer

reco = CommandRecognizer()
commands = reco.commands
len_commands = len(commands)
correct = 0

for i in range(len_commands):
    printout(f"H2: Speak '{commands[i]}'")
    out, _ = reco.recognize()
    if out in commands:
        correct += 1

# Train the model again if more than 50% of the commands doesn't get recognized
if (len_commands - correct) / len_commands > 0.5:
    # TODO: Train again
    pass

# Control passes to CAI Service and script exts

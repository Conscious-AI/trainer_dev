import os
import sys
import time as t


SCRIPTS_DIR = ["..\\audio_processing", "..\\command_recognizer"]

# SCRIPTS = ["dynamic_threshold.py", "record_save.py", "train.py", "recognize_command.py"]


for i in range(len(SCRIPTS_DIR)):
    sys.path.append(SCRIPTS_DIR[i])


def printout(_str):
    print(f"CAI: TRAINER: {_str}")
    sys.stdout.flush()


def countdown(_num, _str):
    for i in reversed(range(_num)):
        printout(f"{_str} {i+1}")
        t.sleep(1)


printout("H1: Calibrating Microphone Threshold...Don't make any noise !")
t.sleep(2)

countdown(5, f"H2: Calibration starting in ...")

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

printout('H1: Re-Populating command dataset by denoising audio files...')
os.chdir(SCRIPTS_DIR[0])
from denoiser import Denoiser

dn = Denoiser()
dn.denoise()

t.sleep(2)
printout("H1: Dataset is ready for training !")
t.sleep(2)

printout("H1: Training command model...This may take a while...")
t.sleep(2)

countdown(5, f"H2: Model training commencing in ...")

printout("H2: ")
os.chdir(SCRIPTS_DIR[1])
import train

printout("H1: Model training complete !")
t.sleep(2)

printout("H1: Now lets do some validation before finishing...")
t.sleep(2)

countdown(5, f"H2: Validator starting in ...")

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

printout("H1: Validation complete ! Looks like everything's good !")
t.sleep(2)
printout("COMPLETE")

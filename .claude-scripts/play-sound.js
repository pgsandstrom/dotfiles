// OS agnostic way to just play a little sound

const { execSync } = require("child_process")
const os = require("os")

const sounds = {
  darwin: "/System/Library/Sounds/Glass.aiff",
  win32: "C:\\Windows\\Media\\notify.wav",
}

const platform = os.platform()
const soundPath = sounds[platform]

if (soundPath) {
  let command
  if (platform === "win32") {
    command = `powershell -Command "(New-Object Media.SoundPlayer '${soundPath}').PlaySync()"`
  } else {
    command = `afplay ${soundPath}`
  }

  try {
    execSync(command, { stdio: "ignore" })
  } catch (error) {
    // Silently fail
  }
}

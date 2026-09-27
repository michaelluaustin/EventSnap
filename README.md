# EventSnap+

Snap a photo of an event flyer and get it on your calendar in seconds.

EventSnap+ is an iOS app that reads a photo of a flyer, brochure, or email screenshot, pulls out the event details with OpenAI's GPT-4o vision model, and lets you review and save the event straight to your iPhone calendar.

## Features

- **Take or choose a photo** of any event flyer
- **Automatic extraction** of the title, start and end time, and location
- **Review before saving**: edit any field and check it against the original image
- **One tap to add** the event to your calendar

## How it works

1. You take or pick a photo.
2. The image is sent to OpenAI's Chat Completions API (`gpt-4o`), which returns the event details as JSON.
3. The details fill in a form you can edit.
4. EventKit saves the event to your calendar.

## Requirements

- Xcode 16 or later
- iOS 17.5 or later
- An [OpenAI API key](https://platform.openai.com/api-keys)

## Getting started

1. Clone the repo:
   ```bash
   git clone https://github.com/michaelluaustin/EventSnap.git
   cd EventSnap
   ```

2. Create your secrets file from the template:
   ```bash
   cp Secrets.example.xcconfig Secrets.xcconfig
   ```

3. Open `Secrets.xcconfig` and add your key:
   ```
   OPENAI_API_KEY = sk-your-key-here
   ```
   `Secrets.xcconfig` is gitignored, so your key stays on your machine.

4. Open `EventSnap.xcodeproj` in Xcode, pick your signing team under **Signing & Capabilities**, and run.

The app asks for camera, photo library, and calendar access the first time it needs each one.

## Project structure

| File | What it does |
| --- | --- |
| `HomeViewController.swift` | Welcome screen |
| `PhotoInputViewController.swift` | Take or choose a photo |
| `ProcessingViewController.swift` | Loading screen while the image is analyzed |
| `EventFormViewController.swift` | Review, edit, and save the extracted event |
| `OpenAIService.swift` | Sends the image to OpenAI and parses the response |
| `ImageProcessor.swift` | Image picking and image-to-data-URI conversion |
| `CalendarManager.swift` | Calendar permissions and saving events with EventKit |

## A note on the API key

The key is read from `Secrets.xcconfig` at build time and included in the app bundle. That's fine for personal and development builds, but anyone with the app file could pull the key out of it. For a public App Store release, route requests through a small backend that holds the key instead.

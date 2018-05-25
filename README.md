Re-implementing Elm's Json.Decode from first principles to try and figure out how it works.

In a nutshell: `Decoder a = Value -> Result String a`

Elm 0.18; Rumor has it 0.19 will remove the native code support I used to do primitive json operations.

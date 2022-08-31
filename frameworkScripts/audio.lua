
SOUNDS = {
}

MUSIC = {
}

MASTER_VOLUME = 1
SFX_VOLUME = 1
MUSIC_VOLUME = 1
trackPitch = 1

SOUNDS_NUM_PLAYING = {}
for id,S in pairs(SOUNDS) do SOUNDS_NUM_PLAYING[id] = 0 end
    
SOUNDS_PLAYING = {}

TRACK_PLAYING = "NONE"
NEW_TRACK = "NONE"

trackTransition = 0
trackTransitionMax = 0

function playTrack(track, transition)

    if track ~= NEW_TRACK and track ~= TRACK_PLAYING then
        NEW_TRACK = track

        trackTransition = transition or 0
        trackTransitionMax = transition or 0
    end

end

function switchTracks()

    local hold = TRACK_PLAYING

    TRACK_PLAYING = NEW_TRACK
    NEW_TRACK = hold
    
end
    
function playSound(string, pitch, maxPlays, vol)
    if (maxPlays or 12) > SOUNDS_NUM_PLAYING[string]  then
        local pitch = pitch or 1
        local NEW_SOUND = SOUNDS[string]:clone(); NEW_SOUND:setPitch(pitch); NEW_SOUND:setVolume((vol or 1) * MASTER_VOLUME * SFX_VOLUME); NEW_SOUND:play()
        table.insert(SOUNDS_PLAYING,{NEW_SOUND, string})
        SOUNDS_NUM_PLAYING[string] = SOUNDS_NUM_PLAYING[string] + 1
    end
end

function processSound()

    for id,S in ipairs(SOUNDS_PLAYING) do
        if not S[1]:isPlaying() then table.remove(SOUNDS_PLAYING,id); SOUNDS_NUM_PLAYING[S[2]] = SOUNDS_NUM_PLAYING[S[2]] - 1 end
    end

    if MUSIC[TRACK_PLAYING] ~= nil then
        MUSIC[TRACK_PLAYING]:setVolume(MUSIC_VOLUME * MASTER_VOLUME * trackVolume)
        MUSIC[TRACK_PLAYING]:setPitch(trackPitch)
        
        if not MUSIC[TRACK_PLAYING]:isPlaying() then MUSIC[TRACK_PLAYING]:play() end
    end

    if MUSIC[NEW_TRACK] ~= nil then
        MUSIC[NEW_TRACK]:setVolume(MUSIC_VOLUME * MASTER_VOLUME * trackVolume)
        MUSIC[NEW_TRACK]:setPitch(trackPitch)
        
        if not MUSIC[NEW_TRACK]:isPlaying() then MUSIC[NEW_TRACK]:play() end
    end
    
    trackTransition = math.max(trackTransition - dt, 0)
    if trackTransition == 0 and NEW_TRACK ~= nil then

        if MUSIC[TRACK_PLAYING] ~= nil then MUSIC[TRACK_PLAYING]:stop() end

        TRACK_PLAYING = NEW_TRACK
        NEW_TRACK = nil
    end

    if trackTransition > 0 then

        if MUSIC[TRACK_PLAYING] ~= nil then
        
            MUSIC[TRACK_PLAYING]:setVolume(MUSIC[TRACK_PLAYING]:getVolume() * (trackTransition / trackTransitionMax))

        end

        if MUSIC[NEW_TRACK] ~= nil then
        
            MUSIC[NEW_TRACK]:setVolume(MUSIC[NEW_TRACK]:getVolume() * (1 - trackTransition / trackTransitionMax))
        
        end

    end

end
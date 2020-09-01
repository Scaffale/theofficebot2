# The office gif bot
A telegram bot to create gif for every situation with the _inline_ interface.

### Build your own
In order to have your bot you'll need:

* Rails >= 6
* ffmpeg (with ogg, subtitles, and libx264)
* your domain (if using telegram)
* telegram bot credentials
* the video you want to use with subtitles

## Creation of usable videos
ffmpeg is great, but if you're not working on a daily basis with video coded it might sound a little complex.

In order to make the bot work you need to answer the query within a couple of seconds. This mean you have
to use ffmpeg only with super fast commands.

Burning subtitles is not a fast command. So you need to do it as a first step.
Take the subtitles and burn them into the video.

##### Extract subtitles
```python
# code to parse file title
exec('ffmpeg')
```

##### Burn subtitles
```python
exec('ffmpeg')
```

Note:
While burning subtitles the frame is shrinked to a suitable dimension for the gifs.

### While not saving the video in mp4 and just cut it?
For how the libx264 encode the video you can't cut it "frame perfect".
Under the hood h264 uses techniques such as _motion compensation_ and so to cut "frame perfet" you have to re-encode it.

This is why I choosed to encode it first to `.ogg` and then to `.mp4` (even the ogg compression is 10 times larger than the mp4)

*Why not keep all ogg?* Telegram requires either `.gif` or `.mp4` to be sent as gifs.

## Database seeding
Once the DB is created you need to seed it with the subtitles extracted previously.
I've created a seed task for that, so run:
```
rails db:seed
```
and it will take one by one all your `.srt` files in the folder `data` and seed the db.

This seed is not smart, it just saves the times of the subtitles and the sentence inside it.

It extracts the season and episode from the subtitle name (expect it to be in `S01E01` format) also it expect to have the `.ogg` file with the same name.

## Deploy telegram bot
Afer inserted all the credentials in the server, and having a `https` connection active on your server you can run
```
bin/rake telegram:bot:set_webhook RAILS_ENV=production
```
and automatically set the webhook. Check [telegram-bot gem](https://github.com/telegram-bot-rb/telegram-bot) for full documentation.

## Dry run test
In the main page you can test your bot with the form.

## Extra
*TBI*
* Saving all queries and keep only most used gifs to save space.
* Compressing existing .mp4 using `-preset veryslow` in background to optimize existing gifs

Enjoy!

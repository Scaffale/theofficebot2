# Plot Twist Bot
A telegram bot to create gif for every situation with the _inline_ interface.

### Build your own
In order to have your bot you'll need:

* Rails >= 6
* ffmpeg (with ogg, subtitles, and libx264)
* your domain (if using telegram) (https is a must)
* telegram bot credentials
* the video you want to use with subtitles

## Creation of usable videos
ffmpeg is great, but if you're not working on a daily basis with video codec it might sound a little complex.

In order to make the bot work you need to answer the query within a couple of seconds. This mean you have
to use ffmpeg only with super fast commands.

There is a rails task to help you with that:
```sh
rails file_adder:compress
```
this comand will compress the video to 480p and burn subtitles inside it.
You need to have in the `data` folder the video files with the subtitles files named the same.
Like: `tlotr.mp4`and `tlotr.srt`. The taks won't work if tthe files aren't named the same.

### While not saving the video in mp4 and just cut it?
For how the libx264 encode the video you can't cut it "frame perfect".
Under the hood h264 uses techniques such as _motion compensation_ and so to cut "frame perfet" you have to re-encode it.

This is why I choosed to encode it first to `.webm` and then to `.mp4` (even the ogg compression is 10 times larger than the mp4)

*Why not keep all webm?* Telegram requires either `.gif` or `.mp4` to be sent as gifs.

## Database seeding
Once the DB is created you need to seed it with the subtitles extracted previously.
I've created a seed task for that, so run:
```
rails db:seed
```
and it will take one by one all your `.srt` files in the folder `data` and seed the db.

This seed is not smart, it just saves the times of the subtitles and the sentence inside it.

The "season episode" feature has been removed.

## Deploy telegram bot
Afer inserted all the credentials in the server (bot token, bot name, server address), and having a `https` connection active on your server you can run
```
bin/rake telegram:bot:set_webhook RAILS_ENV=production
```
and automatically set the webhook. Check [telegram-bot gem](https://github.com/telegram-bot-rb/telegram-bot) for full documentation.

## Dry run test
In the main page you can test your bot with the form.

## Optimize saved gifs
Gifs (mp4 videos) are created with preset `ultrafast` [see ffmpeg libx264 documentation](https://trac.ffmpeg.org/wiki/Encode/H.264). The videos are "huge" and from time to time if you need to save space in the server you can use
```
rails gifs:optimize
```
to compress saved gifs. The preset can be changed in the `sentence` model.

## Todo
* Saving all queries and keep only most used gifs to save space.

Enjoy!

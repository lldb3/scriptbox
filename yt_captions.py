import sys
from youtube_transcript_api import YouTubeTranscriptApi

if len(sys.argv) == 0:
    print("Please provide video id")

# handle full url case
if "youtube.com" in sys.argv[1]:
    vid_id = sys.argv[1].split('v=')[1].split('&')[0]
else:
    vid_id = sys.argv[1]

transcript_obj = YouTubeTranscriptApi.get_transcript(vid_id)

full_text_array = [t['text'] for t in transcript_obj]
full_text = ' '.join(full_text_array)
print(full_text)
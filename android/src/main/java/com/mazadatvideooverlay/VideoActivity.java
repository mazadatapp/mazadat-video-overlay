package com.mazadatvideooverlay;

import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.graphics.RectF;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Handler;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.VideoView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class VideoActivity extends AppCompatActivity {

  VideoView player;
  View rootView;
  ConstraintLayout videoFrame, options_cl;
  ImageView play_pause_im, forward_im, backward_im,fullscreen_im;
  SeekBar seekbar;
  View spacer;
  float dp;
  float OffsetY = 0, VideoSize = 0;
  boolean showOptions = false;
  float last_position=0,first_position;
  boolean isFullScreen=false;
  boolean canMove=false;
  private Handler mHandler = new Handler();
  int stopPosition=0;
  float startY=-1;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_video);
    rootView = findViewById(android.R.id.content).getRootView();
    player = findViewById(R.id.video_player);
    videoFrame = findViewById(R.id.video_frame);
    play_pause_im = findViewById(R.id.play_pause_im);
    forward_im = findViewById(R.id.forward_im);
    backward_im = findViewById(R.id.backward_im);
    fullscreen_im = findViewById(R.id.full_screen_im);
    options_cl = findViewById(R.id.options_cl);
    seekbar = findViewById(R.id.seekbar);
    spacer = findViewById(R.id.spacer);

    dp = getResources().getDisplayMetrics().density;

    String path = getIntent().getExtras().getString("link");
    Uri uri = Uri.parse(path);
    player.setVideoURI(uri);
    //player.setVideoPath("https://videocdn.bodybuilding.com/video/mp4/62000/62792m.mp4");
    player.requestFocus();
    player.start();

    play_pause_im.setOnClickListener(v-> playPausePressed());
    forward_im.setOnClickListener(v-> seekForward());
    backward_im.setOnClickListener(v-> seekBackward());
    fullscreen_im.setOnClickListener(v-> fullscreenPressed());


    // MediaController mediaController = new MediaController(this);


    player.setOnErrorListener(new MediaPlayer.OnErrorListener() {
      @Override
      public boolean onError(MediaPlayer mp, int what, int extra) {
        Log.i("datadata", "error"); // display a toast when an error is occured while playing an video
        return false;
      }
    });

    player.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
      @Override
      public void onCompletion(MediaPlayer mp) {
        stopPosition=0;
        play_pause_im.setImageResource(R.drawable.ic_play);
      }
    });



    setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    player.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
      @Override
      public void onPrepared(MediaPlayer mp) {
        play_pause_im.setImageResource(R.drawable.ic_pause);
        seekbar.setMax(player.getDuration());
        first_position=videoFrame.getY();
        if (mHandler != null) {
          mHandler.postDelayed(UpdateProgress, 100);
        }
      }
    });
    rootView.setOnTouchListener(new View.OnTouchListener() {
      @Override
      public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
          case MotionEvent.ACTION_DOWN:
            RectF rect=new RectF(videoFrame.getLeft(),videoFrame.getY(),videoFrame.getRight(),videoFrame.getY()+ videoFrame.getHeight());
           // Log.i("datadata_top",rect.top+" "+event.getRawY()+ " "+ videoFrame.getY());
            if(rect.contains(event.getRawX(),event.getRawY()) ) {
              OffsetY = event.getRawY() - videoFrame.getY();
              VideoSize = videoFrame.getY() + videoFrame.getHeight() - event.getRawY() + 30 * dp;
              canMove=true;
              startY = event.getRawY();
            }
            //Log.i("datadata", "down "+player.getY());
            return true;
          case MotionEvent.ACTION_MOVE:

            if ((event.getRawY() - OffsetY) > 0 && (event.getRawY() + VideoSize) < getResources().getDisplayMetrics().heightPixels && canMove) {
              //ConstraintLayout.LayoutParams params = videoFrame.generateLayoutParams();
              videoFrame.setY(event.getRawY() - OffsetY);
              last_position=videoFrame.getY();
            }
            //event.getRawY()
            return true;
          case MotionEvent.ACTION_UP:
            if(canMove && startY > event.getRawY()-10 && startY < event.getRawY()+10){
              showOptions = !showOptions;
              options_cl.setVisibility(showOptions ? View.VISIBLE : View.GONE);
            }
            if(!canMove){
              finish();
              mHandler.removeCallbacks(UpdateProgress);
            }
            canMove=false;
            //event.getRawY()
            return true;
        }
        return false;
      }
    });

    seekbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
      @Override
      public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        if (fromUser) {
          player.seekTo(seekBar.getProgress());
        }
      }

      @Override
      public void onStartTrackingTouch(SeekBar seekBar) {

      }

      @Override
      public void onStopTrackingTouch(SeekBar seekBar) {

      }
    });
  }



  @Override
  protected void onResume() {
    super.onResume();
    player.seekTo(stopPosition);
    Log.i("datadata",stopPosition+"");
    player.start();
  }



  @Override
  public void onConfigurationChanged(@NonNull Configuration newConfig) {
    super.onConfigurationChanged(newConfig);


    Log.i("datadata",first_position+" "+last_position);
    videoFrame.setY(first_position);
    ViewGroup.LayoutParams params=videoFrame.getLayoutParams();
    params.width=getResources().getDisplayMetrics().widthPixels;
    if(newConfig.orientation==2) {
      params.height = getResources().getDisplayMetrics().heightPixels;
      spacer.setVisibility(View.VISIBLE);
    }else{
      params.height = (int)(300*dp);
      spacer.setVisibility(View.GONE);
      videoFrame.setY(0);
    }
    Log.i("datadata",getResources().getDisplayMetrics().widthPixels+"");
    videoFrame.setLayoutParams(params);

  }

  public void playPausePressed() {
    if (player.isPlaying()) {
      play_pause_im.setImageResource(R.drawable.ic_play);
      player.pause();
    } else {
      player.start();
      play_pause_im.setImageResource(R.drawable.ic_pause);
    }
  }

  public void seekForward() {
    player.seekTo(player.getCurrentPosition() + 10000);
  }

  public void seekBackward() {
    player.seekTo(player.getCurrentPosition() - 10000);
  }

  private Runnable UpdateProgress = new Runnable() {
    public void run() {
      seekbar.setProgress(player.getCurrentPosition());
      if(player.getCurrentPosition()>0) {
        stopPosition = player.getCurrentPosition();
      }
      //Log.i("datadata",stopPosition+"");
      mHandler.postDelayed(this, 100);
    }
  };
  public void fullscreenPressed(){
    isFullScreen = !isFullScreen;
    if(isFullScreen) {
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
      fullscreen_im.setImageResource(R.drawable.ic_exit_full_screen);
    }else{
      setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
      fullscreen_im.setImageResource(R.drawable.ic_fullscreen);
    }

  }

  @Override
  public void onBackPressed() {

    if(isFullScreen){
      fullscreenPressed();
    }else{
      super.onBackPressed();
      mHandler.removeCallbacks(UpdateProgress);

    }
  }
}

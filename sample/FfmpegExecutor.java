/*
 * For the full copyright and license information, please view the LICENSE file that was distributed
 * with this source code. (c) 2016
 */
package video.ffmpeg;

/**
 * FfmpegExecutor
 * <p/>
 * IMPORTANT: this file must be located in the video.ffmpeg package.
 */
public class FfmpegExecutor {

    static {
        try {
            System.loadLibrary("avutil-54");
            System.loadLibrary("swresample-1");
            System.loadLibrary("avcodec-56");
            System.loadLibrary("avformat-56");
            System.loadLibrary("swscale-3");
            System.loadLibrary("avfilter-5");
            System.loadLibrary("avdevice-56");
            System.loadLibrary("ffmpegexecutor");
        } catch (UnsatisfiedLinkError e) {
            e.printStackTrace();
        }
    }

    /* Log level:
     *   0 - no logs
     *   1 - only error logs
     *   2 - all logs
     */
    private final int logLevel = 2;

    public int execute(String[] args) {
        return run(logLevel, args);
    }

    @SuppressWarnings("JniMissingFunction")
    private native int run(int loglevel, String[] args);

}

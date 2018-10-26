# Prepare data process

```bash
========================Process CSV=====================
csvpath: /home/xfu7/data/sharedTask2nd/test/scst2_testDataSpeech.csv
audiopath: /home/xfu7/data/sharedTask2nd/test/audio
destination: /home/xfu7/kaldi/egs/SpokenCall_Adaptation/s1/data/sharedTask2nd_test
Traceback (most recent call last):
  File "prepare_data.py", line 83, in <module>
    main()
  File "prepare_data.py", line 81, in main
    prepareKaldiData('sc2',test_label_2nd, test_audio_2nd,destination_test)
  File "prepare_data.py", line 46, in prepareKaldiData
    utterance = str(row[3])
IndexError: list index out of range
```
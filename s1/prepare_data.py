import csv
# "5860"  "Sag: Ich bin aus der Türkei"   "5860.wav"      "i'm from turkey"       "correct"       "correct"
# 0       1         2              3            4     5
# utt-id prompt   wav-filename transcription label1 label2 

# Directories
1st_data_dir='/home/xfu7/data/sharedTask1st'
2nd_data_dir='/home/xfu7/data/sharedTask2nd'

# Labels
1st_test_label=1st_data_dir+'/label/scst1_testData_annotated.csv'
1st_train_label=1st_data_dir+'/label/scst1_trainingData_speechTask.csv'

2nd_train_label_A=2nd_data_dir+'/train/scst2_training_data_A_speech.csv'
2nd_train_label_B=2nd_data_dir+'/train/scst2_training_data_B_speech.csv'
2nd_train_label_C=2nd_data_dir+'/train/scst2_training_data_C_speech.csv'
2nd_test_label=2nd_data_dir+'/test/scst2_testDataSpeech.csv'

# Audio files

1st_audio=1st_data_dir+'/audio'
2nd_train_audio=2nd_data_dir+'/train/TrainingDataWavfiles'
2nd_test_audio=2nd_data_dir+'/test/audio'


'''
prepare necessary kaldi data for training
'''
def kaldi_prepare_data():
	


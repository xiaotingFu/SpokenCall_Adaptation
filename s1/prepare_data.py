import csv
# Directories
data_dir_1st='/home/xfu7/data/sharedTask1st'
data_dir_2nd='/home/xfu7/data/sharedTask2nd'

# Labels
test_label_1st=data_dir_1st+'/label/scst1_testData_annotated.csv'
train_label_1st=data_dir_1st+'/label/scst1_trainingData_speechTask.csv'

train_label_A_2nd=data_dir_2nd+'/train/scst2_training_data_A_speech.csv'
train_label_B_2nd=data_dir_2nd+'/train/scst2_training_data_B_speech.csv'
train_label_C_2nd=data_dir_2nd+'/train/scst2_training_data_C_speech.csv'
test_label_2nd=data_dir_2nd+'/test/scst2_testDataSpeech.csv'

# Audio files

audio_1st=data_dir_1st+'/audio'
train_audio_2nd=data_dir_2nd+'/train/TrainingDataWavfiles'
test_audio_2nd=data_dir_2nd+'/test/audio'


destination_train='/home/xfu7/kaldi/egs/st/s1/data/sharedTask2nd/all'
destination_test='/home/xfu7/kaldi/egs/st/s1/data/sharedTask2nd_test'

'''
prepare necessary kaldi data for training
'''
def prepareKaldiData(prefix, csvPath,audioPath, dest):
    # Generating Kaldi format files for ASR training
    textFile = dest+'/text'
    wav_scpFile =dest+'/wav.scp'
    utt2spkFile =dest+'/utt2spk'
    spk2uttFile =dest+'/spk2utt'

    print("========================Process CSV=====================")
    print("csvpath: " + csvPath)
    print("audiopath: " + audioPath)
    print("destination: " + dest)

    with open(csvPath) as csvfile:
            readCSV = csv.reader(csvfile, delimiter='\t')
            for row in readCSV:
                utt_id = prefix + '-' + str(row[0])
                wave_file = str(row[2])
                utterance = str(row[3])

                # Prepare text alignment file
                # File: text
                # utt_id    WORD1 WORD2 WORD3 WORD4 ...
                text_line = utt_id +' '+ utterance+'\n'
                print( "1. text: "+ text_line)
                with open(textFile, 'a+') as out:
                    out.write(text_line)

                # File: wav.scp
                # file_id    path/file
                wavefile_path=audioPath+'/'+wave_file
                wav_scp_line= utt_id + ' ' + wavefile_path +'\n'
                print('2. wav.scp : ' + wav_scp_line)
                with open(wav_scpFile, 'a+') as out:
                    out.write(wav_scp_line)
                    
                # File: utt2spk
                # utt_id    spkr
                utt2spk_line = utt_id +' '+ utt_id+'\n'
                print('3. utt2spk : ' + utt2spk_line)
                with open(utt2spkFile, 'a+') as out:
                    out.write(utt2spk_line)
                with open(spk2uttFile, 'a+') as out:
                    out.write(utt2spk_line)


def main():
    prepareKaldiData('sc1',train_label_1st, audio_1st, destination_train)
    prepareKaldiData('sc1',test_label_1st, audio_1st, destination_train)
    prepareKaldiData('sc2',train_label_A_2nd, train_audio_2nd,destination_train)
    prepareKaldiData('sc2',train_label_B_2nd, train_audio_2nd,destination_train)
    prepareKaldiData('sc2',train_label_C_2nd, train_audio_2nd,destination_train)
    prepareKaldiData('sc2',test_label_2nd, test_audio_2nd,destination_test)

main()
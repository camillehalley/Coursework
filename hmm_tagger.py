import pickle
import sys


class hmm_tagger:
    def __init__(self, data, sentence):
        self.bigramProbs = data[0] #grab data from file
        self.tagProbs = data[1]
        self.qMatrix = data[2]
        self.sentece = sentence.rsplit() #turn sentence into list
        for wordIndex in range(len(self.sentece)):
            self.sentece[wordIndex] = self.sentece[wordIndex].lower()
        self.pS = 1

        self.viterbiCalc()

    def viterbiCalc(self):
        '''
        Iterates through a matrix of possible POS tags for each word in the given sentence and saves the most likely in
        an index backpointer list which is accessed in the last step as the words are paired with their most likely POS's

        Uknown words: handled by yielding to the most likely POS to follow the previous word if the tag is missing, or by yielding
        to the tag if the bigram is unkown

        :return: writes as standard output
        '''
        vit = []
        bp = ['']*(len(self.sentece)+1)#initialize empty backpointer list
        vit.append({'qo': 1}) #account for start
        for i in self.sentece:
            if i in self.qMatrix:
                vit.append(self.qMatrix[i])
            else:
                vit.append({'NN': 1, 'VBP': 1, 'VB': 1, 'PRP': 1, 'JJ': 1, 'RB': 1, 'MD': 1, 'FW':1}) #if word has not been seen, append most common POS
        self.sentece.append('end') # allows algorithm to run fully, will be ingnored in result

        vit.append({'qf': 1})#account for end
        for s in vit[1]:
            if (self.sentece[0], s) in self.bigramProbs:
                vit[1][s] = self.bigramProbs['qo ' + s]*self.tagProbs[self.sentece[0], s]
        for t in range(2, len(self.sentece)):
            for opt in vit[t]:
                vit[t][opt] = float("-inf")
                for sprev in vit[t-1]:
                    if (sprev + ' ' + opt) in self.bigramProbs:
                        vtemp = vit[t-1][sprev]*self.bigramProbs[sprev + ' ' + opt]
                        if vtemp > vit[t][opt]:
                            vit[t][opt] = vtemp
                            bp[t-1] = sprev
            if (self.sentece[t], opt) in self.tagProbs:
                vit[t][opt]*= self.tagProbs[self.sentece[t], opt]

        vfinal = float('-inf')
        for option in vit[-2]:
            if vit[-2] == ' ':
                pass
            else:
                vtemp = vit[-2][option]*self.bigramProbs[option + ' qf']
                if vtemp > vfinal:
                    bp[-1] = option
                    bp.append(' ')
        result = ''
        for wordindex in range(len(self.sentece)-1):
            result += (self.sentece[wordindex] + '/' + bp[(wordindex+1)] + ' ')
        sys.stdout.write(result)
        #print(result)


def main():
    #s = pickle.load(open('model.dat', 'rb'))
    s = pickle.load(open(sys.argv[1], 'rb'))
    testSent = open(sys.argv[2]).read()

    viterbi = hmm_tagger(s, testSent)





if __name__ == '__main__':
    main()
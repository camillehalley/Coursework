import pickle
import math
import string
import sys

class hmm_sequence:

    def __init__(self, data, sentence):
        self.bigramProbs = data[0]
        self.tagProbs = data[1]
        self.sentece = []
        self.pS = 1

        for word in sentence.rsplit():
            words = word.rsplit('/')
            words[0] = words[0].lower()
            self.sentece.append(words)
        self.prob()

    def prob(self):
        '''
        Begins by calculating the probability of the given POS starting the sentence, then iterates
        through summing the probabilities of each POS occurring after the previous POS and each word having
        its assigned POS, finishes by adding the probability of the last word or character
        ending a sentence
        :return: null, prints output

        '''
        self.pS = math.log(self.bigramProbs['qo ' + self.sentece[0][1]]) #q0 transition prob
        for k in range(len(self.sentece)-1): #multiply through by all of the bigram (transition) probailities
            w1 = self.sentece[k][1]
            word1 = self.sentece[k][0]
            w2 = self.sentece[k+1][1]
            if str(w1 + ' ' + w2) in self.bigramProbs:
                self.pS += math.log(self.bigramProbs[w1 + ' ' + w2])
            if (word1, w1) in self.tagProbs:
                self.pS += math.log(self.tagProbs[word1, w1])
        self.pS += math.log(self.bigramProbs[self.sentece[-1][1] + ' qf']) #qf transition prob
        print('The probability for that given tag sequence is: ', self.pS)



def main():
    d = pickle.load(open(sys.argv[1], 'rb'))
    exText = open(sys.argv[2]).read()
    wordProbs = hmm_sequence(d, exText)




if __name__ == '__main__':
    main()


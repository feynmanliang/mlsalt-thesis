# Background

## Music Theory

A score of music is represented using a sequence of notes. Each note represents
a pitch (i.e. frequency) and duration (i.e. time interval).

### Pitches

When discussing pitches, it is common to refer to the difference between two
pitches as **pitch interval**s. One of the most fundamental pitch intervals is the
**octave**, defined to be the interval between a frequency and its double.

While in theory an uncountable number of pitches are available, the tuning
system utilized by a piece of music oftentimes restricts the number of
available pitches. Western music commonly uses **twelve-tone equal
temperament** (12-TET) tuning, which divides an octave into 12 pitch classes
(C, C#/D♭, D, D#/E♭, E, F, F#/G♭, G, G#/A♭, A, A#/B♭, B) all equally spaced on
a logarithmic scale. The interval between two adjacent pitch classes (i.e.
1/12th an octave on log-scale) is called a **half step** and two half steps are
called a **whole step**.

Tonal music is characterized by the prevalence of one pitch class (the
**tonic**) around which the melody and harmony are built. A basic concept
within tonal music is the **scale**, which defines a subset of pitch classes
that are "in key" with respect to the tonic. Two fundamental scales are the
major (with step pattern whole-whole-half-whole-whole-whole-half) and minor
scales (whole-half-whole-whole-half-whole-whole). The choice of tonic and scale
is referred to as the **key**, and a change in key during a piece is called a
**modulation**. Many musical phenomena such as stability, expectation, and
resolution can be attributed to tonal characteristics.

Note that while 12-TET restricts the possible intervals between notes, it does
not define an absolute reference pitch frequency. This degree of freedom gives
rise to transposition invariance: a score of music can be offset by a constant
pitch interval without affecting its tonal characteristics. For practical
performance purposes, the general tuning standard in modern times tunes the "A"
note directly above "middle C" to 440 Hz  ( __A440__ ).

### Durations

The **tempo** of a piece refers to its speed or pace and is measured by beats
per minute. In 4/4 time signature, a **quarter note** or **crotchet** denotes
the time interval between two beats. In addition to pitch quantization,
durations are also commonly quantized to subdivisions and multiples of a
crotchet.


### JCB Chorales Dataset

We use a corpus of Bach chorales provided by `music21`. The chorales are
arranged by the Bach-Werke-Verzeichnis (BWV) numbering system, which is one of
the best known and widely used catalogues of Bach's compositions.

Each chorale has four parts and are structured such that the melody is in
the Soprano part and the remaining parts harmonize the melody.

# Generative Sequence Modeling

Generating a "Bach-like" piece of music can be understood as drawing a random
sample from a distribution over musical scores which is statistically similar
to Bach's own compositions. Thus, we interpret the problem as one of
__generative categorical sequence modeling__.

This type of problem has been well studied. In speech recognition, language
models parameterizing distributions over sentences are used as priors to refine
transcriptions.

However, since our model has to be able to generate Bach, we must be able to
sample from it. This rules out a broad class of sequence models, including
back-off N-grams and other interpolated language models.

Fortunately, low order N-grams and standard HMM-based models are sampleable and
thus can be used as baselines.

## Note-level RNN

RNNs are a sequence model similar to HMMs in that they model the conditional
distribution of next frames given the previous context. However, RNNs additionally
pass along "hidden state" which summarizes contextual information from a potentially
infinite context window.

In practice, it is observed that the hidden state does not capture long range
dependencies well and tend to suffer from vanishing/exploding gradient during
training. LSTMs are an improved RNN architecture which solve both of these
problems by introducing gates on the inputs, hidden state, and outputs. GRUs are
a variation of LSTMs which ties the weights to the input and forget gates.

## RNN-RBM

An alternative design is to have the RNN output the entire chord at teach time.
This is appealing because the steps between successive RNN applications
correspond to units of time. Additionaly, the emission distribution's parameterization
can be used to restrict the number of simultaneous parts.


In a RNN-RBM, the hidden state is used to compute the parameters for a restricted Boltzmann
machine at each timestep. The RBM parameterizess a multivariate categorical distribution,
which can be either over the four parts or the entire piano roll.

__TODO__: experiments here, then describe


## Sequence Modeling

# Experiments

## Data Processing

We transpose all scores with major key signatures to C major and minor key
signatures to A minor. Due to transposition invariance of 12-TET, this does
not alter the tonal properties of the music. ( __TODO__ : convolutional representation
to automatically take care of this invariance, and to allow modulations?).

We represent musical scores using a piano roll representation. Firstly, time is
discretized into constant timestep frames. For each frame, a set of (note, tie)
pairs representing which a note's pitch and whether it is tied
(continuing a note from the previous frame) or newly played notes.

## Generative Polyphonic Model

We use a 2-layer LSTM with a 128-dimensional word embedding.

## Subjective Evaluation: BachBot.com

The frontend utilizes React and Redux, allowing us to collect fine-grained user
action data. Azure App Service is used to host an Express web-service which
randomizes experimental questions and collects responses. The data is stored to
Azure Data Storage and processed in batch MapReduce using Azure HDInsight.

We ask users to rate themselves on their musical skills (0-10) and present the
user with five questions. Each questions asks the user to listen to two
samples, one generated and one original Bach, and tasks the user to select the
original. In addition to the question response, we collect data on the time
spent on a questions and number of times each sample is played.

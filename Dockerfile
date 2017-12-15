FROM jupyter/minimal-notebook:latest

# Install requirements
WORKDIR /tmp
ADD requirements.txt .
RUN pip install -r requirements.txt
RUN python -m nltk.downloader punkt
RUN python -m nltk.downloader wordnet
RUN python -m textblob.download_corpora
RUN python -m spacy download en

# Set the working directory
WORKDIR /home/jovyan
ADD *.ipynb /home/jovyan/
ADD *.py /home/jovyan/
ADD html /home/jovyan/html
ADD stop.txt /home/jovyan
ADD terms.tsv /home/jovyan

# Allow user to write to directory
USER root
RUN chown -R $NB_USER /home/jovyan \
    && chmod -R 774 /home/jovyan                                                                              

# Make the student-edited files writable
#RUN for i in "a1.json", "a2.json", "a3.json", "a4.json", "model.dat" ; do touch /home/jovyan/$i ; chmod o+w /home/jovyan/$i ; done
USER $NB_USER

# Expose the notebook port
EXPOSE 8888

# Start the notebook server
CMD jupyter notebook --no-browser --port 8888 --ip=*

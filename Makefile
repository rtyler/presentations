
PDF_FILE="juc-tokyo.pdf"

$(PDF_FILE): clean
	pinpoint juc-tokyo.pin -o $(PDF_FILE)


clean:
	rm -f $(PDF_FILE)

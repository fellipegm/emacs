;; These functions use pdfcrop to crop a given pdf file, usually to use as a figure in latex or in a presentation
;; and function fgm/pdf-to-png uses pdftoppm to convert from pdf to png, which is used to make presentations.

(defun fgm/crop-pdf (directory)
  (interactive "DEnter directory to crop pdf files: ")

  (shell-command (format "find \"%s\" -name \"*-crop.pdf\" -delete" directory) nil nil)

  (setq-local files (directory-files directory t ".*.pdf"))

  (dolist (file files)
    (shell-command (format "pdfcrop \"%s\" \"%s-crop.pdf\""
			   file
			   (file-name-sans-extension file)) nil nil ))) 

(defun fgm/pdf-to-png (directory)
  (interactive "DEnter directory to transform all the pdf files to png: ")

  (setq-local files (directory-files directory t ".*.pdf"))

  (dolist (file files)
    (shell-command (format "pdftoppm -png \"%s\" > \"%s.png\""
			   file
			   (file-name-sans-extension file)) nil nil)))

(defun fgm/crop-pdf-and-transform-to-png (directory)
  (interactive "DEnter directory to crop the pdf files and then transform to png: ")

  (fgm/crop-pdf directory)
  (fgm/pdf-to-png directory))

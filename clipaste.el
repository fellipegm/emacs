;; This was based originally from https://mpas.github.io/posts/2021/03/29/2021-03-29-paste-image-from-clipboard-directly-into-org-mode-document/

;; Overview
;; --------
;; Inserts an image from the clipboard by prompting the user for a filename.
;; Default extension for the pasted filename is .png

;; An images directory will be created relative to the current Org-mode document to store the images.

;; The default name format of the pasted image is:
;; filename: <yyyymmdd>_<hhmmss>_-_<image-filename>.png

;; Important
;; --------
;; This function depends on 'xclip' to paste the clipboard image

;; Basic Customization
;; -------------------
;; Include the current Org-mode header as part of the image name.
;; (setq my/insert-clipboard-image-use-headername t)
;; filename: <yyyymmdd>_<hhmmss>_-_<headername>_-_<image-filename>.png

;; Include the buffername as part of the image name.
;; (setq my/insert-clipboard-image-use-buffername t)
;; filename: <yyyymmdd>_<hhmmss>_-_<buffername>_-_<image-filename>.png

;; Full name format
;; filename: <yyyymmdd>_<hhmmss>_-_<buffername>_-_<headername>_-_<image-filename>.png
(defun fgm/insert-clipboard-image (filename)
  "Inserts an image from the clipboard"
  (interactive "sFilename to paste: ")
  (let ((folder "figures/"))
    (let ((file
	   (concat
	    (file-name-directory buffer-file-name)
	    folder
	    (format-time-string "%d%m%Y_%H%M%S")
	    (if (bound-and-true-p fgm/insert-clipboard-image-use-buffername)
		(concat "_-_" (s-replace "-" "_"
				   (downcase (file-name-sans-extension (buffer-name)))))
	      "")
	    (if (bound-and-true-p fgm/insert-clipboard-image-use-headername)
		(concat "_-_" (s-replace " " "_" (downcase (nth 4 (org-heading-components))))))
	    (if (equal filename "")
		"" "_-_") 
	    filename ".png")))
      ;; create images directory
      (unless (file-exists-p (file-name-directory file))
	(make-directory (file-name-directory file)))

      ; TODO: of course, the ideal is to verify if it is possible to paste the image as image/png, however, I am having trouble to parse the output of the command xclip -selection clipboard -target TARGETS -o from elisp. The xclip hangs...
      ; xclip hangs when called, had to include a timeout to make sure the process is terminated
      (shell-command (format "timeout 0.2 xclip -selection clipboard -target image/png -o 1> \"%s\"" file ))
      (shell-command (format "find \"%s\" -size 0c -delete" (file-name-directory (expand-file-name file)) ))
      (if (file-exists-p file)
	  (insert (concat "./" folder (file-name-nondirectory file)))
	  (message "Not possible to paste image")))))

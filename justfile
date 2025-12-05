report:
    #!/bin/sh

    xdg-open ./main.pdf&
    typst watch ./main.typ --root=. 

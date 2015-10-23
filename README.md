# AssemblyLanguage
pacman
ghostd nono
blinky yellow
dots eat dots

levelArray = 2d array of walls and pacman and dots
curPos = where pacman is


until(dots == 0){

	startCounter()

	until(counter == 1 sec){
		read keyboardInput	
	}

	if (keyboardInput){
		nextPos = curPos+directionOfKeyboardInput
		nextPosValue = levelarray[nextPos]

		if (nextPosValue == wall){
			break
		}
		else if (nextPosValue == dot){
			replace pos in array with pacman
			score++
		}
		else if (nextPosValue == free){
			replace pos in array with pacman
		}

		updatescreen()

	}
}

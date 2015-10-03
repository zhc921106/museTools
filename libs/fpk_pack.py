#encode=UTF-8
import shutil
import os

src_dir  = '/data/muse/game-01/trunk/musegame/src'
code_dir = '/data/muse/game-01/trunk/musegame/code'
fpk_path = '/data/muse/tools/libs/fpk'
to_path  = '/data/muse/game-01/trunk/musegame/res/musegame'

# move src to code
def moveSrc2Code():
	# if src is exist
	if not os.path.isdir(src_dir):
		print 'src is not a director , faild !!'
		return False
	if len(os.listdir(src_dir)) == 0:
		print 'src is nil director , faild !!'
		return False

	# if code is exist then rm code director
	if os.path.exists(code_dir):
		shutil.rmtree(code_dir)
		print 'rm old code -- ok'

	shutil.copytree(src_dir,code_dir)

	# if copy success , mkdir src
	# else ask user if repeat
	if not os.path.exists(code_dir):
		print 'copy faild !!!'
		return False
	elif len(os.listdir(code_dir)) == 0:
		print 'copy faild !!!'
		return False
	else :
		print 'copy success, then mkdir director src ...'
		shutil.rmtree(src_dir)
		os.mkdir(src_dir)
		return True


def package():
	os.system(fpk_path + ' ' + code_dir + ' ' + to_path)
	print 'package ok !'

def main():
	move_ok = moveSrc2Code()
	if move_ok:
		package()


main()

































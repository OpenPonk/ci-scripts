# Project, Model, Diagram

OpenPonk application is implemented in Pharo programming environment that can be described as a programming OS running in a VirtualBox-like virtual machine.
In the OpenPonk application, you may open multiple OpenPonk windows, each representing an OpenPonk project.
In each OpenPonk project, you may have multiple independent models.
Models contain elements, their properties and relations without any visual representation.
The visual representation is provided by a diagram. One model can be shown using many diagrams and these diagrams may only show small part of the model.

When you add new elements, delete them or change their properties, you change not only the current diagram, but also the model used for all the diagrams of the same model.
If you wish to omit (hide) some elements from a diagram, but keep them in the model (and possibly other diagrams), use Hide menu items. To show them again, use Show.

# Saving

There are two independent saving systems: saving entire OpenPonk environment and saving a single project into a project file. It is recommended to save using both ways after doing lots of work that you really do not want to lose, as any of these systems can glitch out, especially the first option.

1) Saving OpenPonk environment:
	You may save whole OpenPonk application environment, including open windows, dialog popups, not-yet-properly-saved projects etc. This is very convenient as you save multiple projects at once and everything opens exactly like you saved it. However, if the OpenPonk application glitches and refuses to open, you lose everything that is only saved this way.
	It is saved into .image and .changes files inside image directory. These files can become very large and unsuitable for moving to other computers, as the .image file is a full memory serialization.

	How to save this way (2 alternatives):
		- In very top toolbar > Pharo > Save (or Save and Quit)
		or
		- When attempting to close the OP app window, it asks if you want to save changes. Picking Save does exactly this kind of save.

	How to load this kind of save:
		- Just open OpenPonk application again

2) Saving a single project:
	You may save a single project to an .opp (OpenPonk Project) file, which is a zip file with various text files (like xml, json or similar) with project metadata, models, diagrams etc.

	How to save this way:
		- In OpenPonk project's sub-window > Project > Save Project

	How to load this kind of save (2 alternatives):
		- In very top toolbar > OpenPonk > Open Project...
		or
		- Drag and drop the .opp file onto the window of running OpenPonk (if it is supported by your OS / file browser)

# Settings

OpenPonk settings are available from an open project's internal window, using this window's menu: OpenPonk > Settings

# Dragging/Moving elements

Whenever you are dragging elements of a diagram, elements automatically snap to the centre or borders of nearby elements when dragged.
To disable snapping for the current drag, hold Alt key when dragging.
To permanently disable it, go to OpenPonk settings and set "Shapes checked for drag snapping" to 0

# Keyboard shortcuts

All keyboard shortcuts only work inside drawing area and there are currently no shortcuts for project itself.
Activating keyboard shortcuts sometimes needs clicking into canvas area once again, even if it is responding to mouse already.

Scroll diagram:	arrows
Zoom in/out:	+/-
Delete element:	Delete (with confirmation dialog) or Shift + Delete (without confirmation)
Hide element:	Ctrl + H
Save OpenPonk environment (first saving option): Ctrl + Shift + S


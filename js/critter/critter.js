/*
 * critter.js
 *
 * Author:  Sami Tanskanen
 * Date:    2021/09/02
 * Comment: I've no idea what I'm doing. Sorry for wasting your CPU cycles.
 */

const EMAIL = atob("c2FtaUB3aWx5d2lseS5jb20=");

const can = document.getElementById("critter");
const con = can.getContext("2d");

const TAU = Math.PI * 2;
const PI = Math.PI;
const HALF_PI = Math.PI / 2;
const QUARTER_PI = HALF_PI / 2;
const EIGHTH_PI = QUARTER_PI / 2;
const XSCALE = 1920 / screen.width;
const STEP = screen.width / 1100 * XSCALE;
const VEL_LIMIT = STEP * 5;
const SEGMENT_LENGTH = STEP * 20;
const SEGMENT_WIDTH = SEGMENT_LENGTH / 2;
const ANTENNA_RADIUS = SEGMENT_WIDTH / 4;
const WIDTH_MOD = SEGMENT_WIDTH / 4;
const TOTAL_SEGMENTS = 9;

var dt;
var prev_t = 0;
var frames = 0;

// Signed delta angle
function angDiff(source_angle, target_angle) {
	let angle = (target_angle - source_angle);
	if (angle > PI) {
		angle -= TAU;
	} else if (angle < -PI) {
		angle += TAU;
	}
	return angle;
}
function vecMag(vec) {
	return Math.sqrt(vec.x**2 + vec.y**2);
}
function vecMaxMag(vec, max) {
	let mag = vecMag(vec);
	if (mag > max) {
		let mult = max / mag;
		vec.x *= mult;
		vec.y *= mult;
	}
}
// function dotProduct(vec1, vec2) {
// 	return vec1.x * vec2.x + vec1.y * vec2.y;
// }
// function vecAngle(vec1, vec2) {
// 	return Math.acos(dotProduct(vec1, vec2) / (vecMag(vec1) * vecMag(vec2)));
// }
function vecClampPos(vec, min_x, min_y, max_x, max_y) {
	vec.x = Math.max(min_x, Math.min(vec.x, max_x));
	vec.y = Math.max(min_y, Math.min(vec.y, max_y));
}
function vecDist(vec1, vec2) {
	return Math.sqrt((vec2.x - vec1.x)**2 + (vec2.y - vec1.y)**2);
}
function vecAdd(vec1, vec2) {
	vec1.x += vec2.x;
	vec1.y += vec2.y;
}

function resizeCanvas() {
	can.width = window.innerWidth;
	can.height = window.innerHeight;

	con.imageSmoothingEnabled = false;
	con.font = "22px sans-serif";
	con.textAlign = "end";
	con.textBaseline = "bottom";

	con.fillStyle = "#FFFFFF";
	con.strokeStyle = "#888888";
	con.lineWidth = SEGMENT_WIDTH / 5;
}

function Critter() {
	var dir = Math.random() * TAU;
	var vec_pos = { x: can.width / 2, y: can.height / 2 };
	var vec_vel = { x: 0, y: 0 };
	var leg_phase = 0;
	var segments = { x: [], y: [] };

	segments.x[0] = vec_pos.x;
	segments.y[0] = vec_pos.y;
	for (i = 0; i < TOTAL_SEGMENTS - 1; i++) {
		let angle = dir + (TAU / TOTAL_SEGMENTS * i);
		segments.x[i + 1] = segments.x[i] - Math.cos(angle) * SEGMENT_LENGTH;
		segments.y[i + 1] = segments.y[i] - Math.sin(angle) * SEGMENT_LENGTH;
	}

	this.update = function() {
		let vec_adjust = { x: 0, y: 0 };
		let prev_dir = dir;

		if (vec_pos.x <= SEGMENT_LENGTH) {
			vec_adjust.x += STEP;
		} else if (vec_pos.x >= can.width - SEGMENT_LENGTH) {
			vec_adjust.x -= STEP;
		}
		if (vec_pos.y <= SEGMENT_LENGTH) {
			vec_adjust.y += STEP;
		} else if (vec_pos.y >= can.height - SEGMENT_LENGTH) {
			vec_adjust.y -= STEP;
		}

		if (vec_adjust.x === 0 && vec_adjust.y === 0) {
			dir = prev_dir + (Math.random() * QUARTER_PI - EIGHTH_PI);
		} else {
			let vec_vel_dir = Math.atan2(vec_vel.y, vec_vel.x);
			let vec_adjust_dir = Math.atan2(vec_adjust.y, vec_adjust.x);
			let adjustment = angDiff(vec_vel_dir, vec_adjust_dir);
			dir = prev_dir + (adjustment / 15) + (Math.random() * QUARTER_PI - EIGHTH_PI);
		}

		let vec_acc = {
			x: Math.cos(dir) * STEP,
			y: Math.sin(dir) * STEP
		};
		vecAdd(vec_vel, vec_acc);
		vecMaxMag(vec_vel, VEL_LIMIT);

		let vec_prev_pos = {
			x: vec_pos.x,
			y: vec_pos.y
		};
		vecAdd(vec_pos, vec_vel);
		vecClampPos(
			vec_pos,
			SEGMENT_LENGTH,
			SEGMENT_LENGTH,
			can.width - SEGMENT_LENGTH,
			can.height - SEGMENT_LENGTH
		);

		segments.x[0] = vec_pos.x;
		segments.y[0] = vec_pos.y;
		for (i = 0; i < TOTAL_SEGMENTS - 1; i++) {
			let angle = Math.atan2(
				segments.y[i] - segments.y[i + 1],
				segments.x[i] - segments.x[i + 1]
			);
			segments.x[i + 1] = segments.x[i] - Math.cos(angle) * SEGMENT_LENGTH;
			segments.y[i + 1] = segments.y[i] - Math.sin(angle) * SEGMENT_LENGTH;
		}

		leg_phase += vecDist(vec_prev_pos, vec_pos) / 8;
	}

	this.draw = function() {
		let width_mod = Math.sin(frames / 15) * WIDTH_MOD;
		let begin_angle = Math.atan2(
			segments.y[1] - segments.y[0],
			segments.x[1] - segments.x[0]
		);
		let begin_width = SEGMENT_WIDTH + width_mod;
		let leg_wave = Math.sin(leg_phase) * QUARTER_PI;
		let leg_angle1 = begin_angle + EIGHTH_PI + leg_wave;
		let leg_angle2 = begin_angle - EIGHTH_PI - leg_wave;
		let leg_length = SEGMENT_WIDTH + begin_width / 2;

		let whisker_length = SEGMENT_LENGTH + width_mod / 2;
		let whisker1_x = vec_pos.x + Math.cos(dir - EIGHTH_PI) * whisker_length;
		let whisker1_y = vec_pos.y + Math.sin(dir - EIGHTH_PI) * whisker_length;
		let whisker2_x = vec_pos.x + Math.cos(dir + EIGHTH_PI) * whisker_length;
		let whisker2_y = vec_pos.y + Math.sin(dir + EIGHTH_PI) * whisker_length;

		// Antennae
		con.beginPath();
		con.moveTo(whisker1_x, whisker1_y);
		con.lineTo(vec_pos.x, vec_pos.y);
		con.lineTo(whisker2_x, whisker2_y);
		con.stroke();

		con.beginPath();
		con.arc(whisker1_x, whisker1_y, ANTENNA_RADIUS, 0, TAU);
		con.fill();
		con.stroke();
		con.beginPath();
		con.arc(whisker2_x, whisker2_y, ANTENNA_RADIUS, 0, TAU);
		con.fill();
		con.stroke();

		// Frontmost legs
		con.beginPath();
		con.moveTo(segments.x[0] + Math.cos(leg_angle1) * leg_length,
				   segments.y[0] + Math.sin(leg_angle1) * leg_length);
		con.lineTo(segments.x[0], segments.y[0]);
		con.lineTo(segments.x[0] + Math.cos(leg_angle2) * leg_length,
				   segments.y[0] + Math.sin(leg_angle2) * leg_length);
		con.stroke();

		// Head
		con.beginPath();
		con.moveTo(segments.x[0] + Math.cos(begin_angle - HALF_PI) * begin_width,
				   segments.y[0] + Math.sin(begin_angle - HALF_PI) * begin_width);
		con.lineTo(segments.x[0] + Math.cos(begin_angle + HALF_PI) * begin_width,
				   segments.y[0] + Math.sin(begin_angle + HALF_PI) * begin_width);
		con.lineTo(segments.x[0] + Math.cos(begin_angle - PI) * begin_width,
	 			   segments.y[0] + Math.sin(begin_angle - PI) * begin_width);
		con.closePath();
		con.fill();
		con.stroke();

		// Body + legs
		for (let i = 0; i < TOTAL_SEGMENTS - 1; i++) {
			let multiplier = 1 - (i + 1) / TOTAL_SEGMENTS;
			width_mod = Math.sin((frames + multiplier * 100) / 15) * WIDTH_MOD;
			let end_angle = Math.atan2(
				segments.y[i + 1] - segments.y[i],
				segments.x[i + 1] - segments.x[i]
			);
			let end_width = Math.max(SEGMENT_WIDTH * multiplier + width_mod, 1);

			leg_wave = Math.sin(leg_phase * multiplier) * QUARTER_PI;
			leg_angle1 = begin_angle + EIGHTH_PI + leg_wave;
			leg_angle2 = begin_angle - EIGHTH_PI - leg_wave;
			leg_length = SEGMENT_WIDTH + end_width / 2;

			/// Legs
			con.beginPath();
			con.moveTo(segments.x[i + 1] + Math.cos(leg_angle1) * leg_length,
					   segments.y[i + 1] + Math.sin(leg_angle1) * leg_length);
			con.lineTo(segments.x[i + 1], segments.y[i + 1]);
			con.lineTo(segments.x[i + 1] + Math.cos(leg_angle2) * leg_length,
					   segments.y[i + 1] + Math.sin(leg_angle2) * leg_length);
			con.stroke();

			/// Body segment
			con.beginPath();
			con.moveTo(segments.x[i] + Math.cos(begin_angle + HALF_PI) * begin_width,
					   segments.y[i] + Math.sin(begin_angle + HALF_PI) * begin_width);
			con.lineTo(segments.x[i] + Math.cos(begin_angle - HALF_PI) * begin_width,
					   segments.y[i] + Math.sin(begin_angle - HALF_PI) * begin_width);

			if (i & 1 === 0) {
				con.lineTo(segments.x[i + 1] + Math.cos(begin_angle - HALF_PI) * begin_width,
						   segments.y[i + 1] + Math.sin(begin_angle - HALF_PI) * begin_width);
				con.lineTo(segments.x[i + 1] + Math.cos(begin_angle + HALF_PI) * begin_width,
						   segments.y[i + 1] + Math.sin(begin_angle + HALF_PI) * begin_width);
			} else {
				con.lineTo(segments.x[i + 1] + Math.cos(begin_angle + HALF_PI) * begin_width,
						   segments.y[i + 1] + Math.sin(begin_angle + HALF_PI) * begin_width);
				con.lineTo(segments.x[i + 1] + Math.cos(begin_angle - HALF_PI) * begin_width,
						   segments.y[i + 1] + Math.sin(begin_angle - HALF_PI) * begin_width);
			}
			con.closePath();
			con.fill();
			con.stroke();

			begin_angle = end_angle;
			begin_width = end_width;
		}

		con.fillText(EMAIL, can.width - 2, can.height - 2);
	}
}

function update(t) {
	// t /= 1000;
	// dt = t - prev_t;
	// prev_t = t;

	con.clearRect(0, 0, can.width, can.height);
	critter.update();
	critter.draw();

	frames++;
	window.requestAnimationFrame(update);
}

window.addEventListener('resize', resizeCanvas, false);
resizeCanvas();
var critter = new Critter();
window.requestAnimationFrame(update);

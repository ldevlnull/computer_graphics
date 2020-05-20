package oleksii.ulianov;

import java.util.Optional;

public class Line {

	private final Point p1;
	private final Point p2;
	private final Type type;

	enum Type {
		SEGMENT, // відрізок
		RAY, // промінь
		STRAIGHT_LINE // пряма
	}

	private Line(Point p1, Point p2, Type type) {
		this.p1 = p1;
		this.p2 = p2;
		this.type = type;
	}

	public static Line segmentOf(Point p1, Point p2) {
		return new Line(p1, p2, Type.SEGMENT);
	}

	public static Line segmentOf(float x1, float y1, float x2, float y2) {
		return new Line(Point.of(x1, y1), Point.of(x2, y2), Type.SEGMENT);
	}

	public static Line rayOf(Point p1, Point p2) {
		return new Line(p1, p2, Type.RAY);
	}

	public static Line rayOf(float x1, float y1, float x2, float y2) {
		return new Line(Point.of(x1, y1), Point.of(x2, y2), Type.RAY);
	}

	public static Line straightOf(Point p1, Point p2) {
		return new Line(p1, p2, Type.STRAIGHT_LINE);
	}

	public static Line straightOf(float x1, float y1, float x2, float y2) {
		return new Line(Point.of(x1, y1), Point.of(x2, y2), Type.STRAIGHT_LINE);
	}

	public boolean interferenceWith(Line line) {
		return findInterferencePoint(line).isPresent();
	}

	public Optional<Point> findInterferencePoint(Line line) {
		float angle_k = (p2.getY() - p1.getY()) * (line.p1.getX() - line.p2.getX()) - (line.p2.getY() - line.p1.getY()) * (p1.getX() - p2.getX());

		if (angle_k == 0) {
			System.out.println(this + " and " + line + " are parallel.");
			return Optional.empty(); // parallel
		}
		float c1 = p2.getY() * p1.getX() - p2.getX() * p1.getY();
		float c2 = line.p2.getY() * line.p1.getX() - line.p2.getX() * line.p1.getY();

		float x = (c1 * (line.p1.getX() - line.p2.getX()) - c2 * (p1.getX() - p2.getX())) / angle_k;
		float y = (c2 * (p2.getY() - p1.getY()) - c1 * (line.p2.getY() - line.p1.getY())) / angle_k;

		if (isPointBeyondLine(line, x, y))
			return Optional.empty();

		return Optional.of(Point.of(x, y));
	}

	private boolean isPointBeyondLine(Line line, float x, float y) {
		return x > Math.max(line.p1.getX(), line.p2.getX())
				|| x < Math.min(line.p1.getX(), line.p2.getX())
				|| y > Math.max(line.p1.getY(), line.p2.getY())
				|| y < Math.min(line.p1.getY(), line.p2.getY());
	}

	@Override
	public String toString() {
		return String.format("%s{%s; %s}", type.name(), p1, p2);
	}

	public Point getP1() {
		return p1;
	}

	public Point getP2() {
		return p2;
	}

	public Type getType() {
		return type;
	}
}

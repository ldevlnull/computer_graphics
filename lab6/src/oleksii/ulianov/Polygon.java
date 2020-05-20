package oleksii.ulianov;


import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;

public class Polygon {

	private final LinkedHashSet<Point> points;
	private Boolean isConvex; // чи є опуклим

	private Polygon(LinkedHashSet<Point> points) {
		this.points = points;
	}

	public static Polygon empty() {
		return new Polygon(new LinkedHashSet<>());
	}

	public static Polygon of(Collection<Point> points) {
		return new Polygon(new LinkedHashSet<>(points));
	}

	public static Polygon of(Point... points) {
		return new Polygon(Arrays.stream(points).collect(Collectors.toCollection(LinkedHashSet::new)));
	}

	public Polygon addPoint(Point point) {
		if (!points.add(point)) {
			System.out.println("Polygon already has point " + point);
		}
		return this;
	}

	public Polygon addPoint(float x, float y) {
		return addPoint(Point.of(x, y));
	}

	public Polygon removePoint(Point point) {
		if (!points.remove(point)) {
			System.out.println("Polygon doesn't have point " + point);
		}
		return this;
	}

	public boolean isConvex() {
		if (isConvex == null)
			checkConvexity();

		return isConvex;
	}

	private void checkConvexity() {
		Queue<Point> queue = new LinkedList<>();
		Iterator<Point> iterator = points.iterator();
		List<Float> Ds = new LinkedList<>();

		queue.add(iterator.next());
		queue.add(iterator.next());
		while (iterator.hasNext()) {
			queue.add(iterator.next());

			Point[] p = queue.toArray(new Point[]{});
			float D = p[0].getX() * p[1].getY() + p[1].getX() * p[2].getY() + p[2].getX() * p[0].getY();
			Ds.add(D);

			queue.poll();
		}
		isConvex = Ds.stream().allMatch(D -> D >= 0) || Ds.stream().allMatch(D -> D < 0);
	}

	public boolean interferenceWith(Line line) {
		AtomicBoolean hasVertexLeft = new AtomicBoolean(false), hasVertexRight = new AtomicBoolean(false);
		points.forEach(point -> {
			float x3 = point.getX(), y3 = point.getY();
			float D = (x3 - line.getP1().getX()) * (line.getP2().getY() - line.getP1().getY())
					- (y3 - line.getP1().getY()) * (line.getP2().getX() - line.getP1().getX());
			if (D > 0) {
				hasVertexRight.set(true);
			}
			if (D < 0) {
				hasVertexLeft.set(true);
			}
		});
		return hasVertexLeft.get() && hasVertexRight.get();
	}

	@Override
	public String toString() {
		return "Polygon" + points;
	}

	public LinkedHashSet<Point> getPoints() {
		return points;
	}

}

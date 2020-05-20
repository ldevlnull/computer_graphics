package oleksii.ulianov;


public class Main {
	public static void main(String[] args) {
		Line l1 = Line.straightOf(1, 1, 6, 4);
		Line l2 = Line.straightOf(2, 1, 3, 3);
		Line l3 = Line.straightOf(1, 2, 2, 5);
		Line l4 = Line.segmentOf(2, 2, 1, -1);

		Polygon p1 = Polygon.empty()
				.addPoint(3, 6)
				.addPoint(4, 2)
				.addPoint(6, 4)
				.addPoint(4, 7);

		Polygon p2 = Polygon.empty()
				.addPoint(1, 1)
				.addPoint(2, 3)
				.addPoint(4, 1)
				.addPoint(6, 0)
				.addPoint(2, -3);

//		System.out.println("p1.isConvex() = " + p1.isConvex());
//		System.out.println("p2.isConvex() = " + p2.isConvex());
//		System.out.println("p2.interferenceWith(l2) = " + p2.interferenceWith(l2));
//		System.out.println("p2.interferenceWith(l3) = " + p2.interferenceWith(l3));

		System.out.println("l4.interferenceWith(l1) = " + l4.interferenceWith(l1));
		System.out.println("l4.interferenceWith(l2) = " + l4.interferenceWith(l2));
		System.out.println("l4.interferenceWith(l3) = " + l4.interferenceWith(l3));

		Plot.empty()
//				.add(p1)
				.add(l1)
				.add(l2)
				.add(l3)
				.add(l4)
//				.add(p2)
				.run();
	}
}

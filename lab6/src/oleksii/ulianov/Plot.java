package oleksii.ulianov;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.annotations.XYPolygonAnnotation;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;

import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.util.List;

public class Plot implements Runnable {

	private final List<LinkedHashSet<Point>> points;

	private Plot(List<LinkedHashSet<Point>> points) {
		this.points = points;
	}

	public static Plot of(Collection<Point> points) {
		Plot plot = Plot.empty();
		points.forEach(plot::add);
		return plot;
	}

	public static Plot empty() {
		return new Plot(new ArrayList<>());
	}

	public Plot add(Point point) {
		this.points.add(new LinkedHashSet<>(Collections.singleton(point)));
		return this;
	}

	public Plot add(Line line) {
		LinkedHashSet<Point> list = new LinkedHashSet<>();
		switch (line.getType()) {
			case SEGMENT:
				list.add(line.getP1());
				list.add(line.getP2());
				break;
			case RAY:
				Point extended = Point.of(
						Integer.MAX_VALUE * (line.getP2().getX() - line.getP1().getX()) + line.getP2().getX(),
						Integer.MAX_VALUE * (line.getP2().getY() - line.getP1().getY()) + line.getP2().getY()
				);
				list.add(line.getP1());
				list.add(extended);
				break;
			case STRAIGHT_LINE:
				Point extendedFromP2 = Point.of(
						Integer.MAX_VALUE * (line.getP2().getX() - line.getP1().getX()) + line.getP2().getX(),
						Integer.MAX_VALUE * (line.getP2().getY() - line.getP1().getY()) + line.getP2().getY()
				);
				Point extendedFromP1 = Point.of(-extendedFromP2.getX(), -extendedFromP2.getY());
				list.add(extendedFromP1);
				list.add(extendedFromP2);
				break;
		}
		points.add(list);
		return this;
	}

	public Plot add(Polygon polygon) {
		this.points.add(polygon.getPoints());
		return this;
	}

	@Override
	public void run() {
		XYSeriesCollection dataset = new XYSeriesCollection();
		Set<XYPolygonAnnotation> polygonsToDraw = new HashSet<>();
		for (int i = 0; i < points.size(); i++) {
			if (points.get(i).size() > 2) {
				double[] arr = new double[points.get(i).size() * 2];
				Iterator<Point> iterator = points.get(i).iterator();
				for (int j = 0; j < arr.length; j += 2) {
					Point p = iterator.next();
					arr[j] = p.getX();
					arr[j + 1] = p.getY();
				}
				polygonsToDraw.add(new XYPolygonAnnotation(arr));
			} else {
				XYSeries xySeries = new XYSeries(i + 1);
				points.get(i).forEach(p -> xySeries.add(p.getX(), p.getY()));
				points.get(i).stream().findFirst().ifPresent(p -> xySeries.add(p.getX(), p.getY()));
				dataset.addSeries(xySeries);
			}
		}

		JFreeChart chart = ChartFactory.createXYLineChart("Plot", "x", "y", dataset,
				PlotOrientation.VERTICAL, true, true, true);

		XYPlot plot = chart.getXYPlot();
		NumberAxis numberAxis = (NumberAxis) plot.getRangeAxis();
		numberAxis.setRange(-4, 8);
		plot.getDomainAxis().setRange(-4, 8);
		polygonsToDraw.forEach(plot::addAnnotation);

		JFrame frame = new JFrame("Plot");
		frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		frame.setPreferredSize(new Dimension(800, 600));
		frame.setContentPane(new ChartPanel(chart));
		frame.setLocationRelativeTo(null);
		frame.pack();
		frame.setVisible(true);
	}
}

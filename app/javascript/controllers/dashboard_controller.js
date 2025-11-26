import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"

export default class extends Controller {
  static targets = ["quotationsByStatus", "projectsByType", "quotationsByMonth"]

  static values = {
    quotationsByStatus: Object,
    projectsByType: Object,
    quotationsByMonth: Object
  }

  connect() {
    this.charts = {}
    this.initCharts()
  }

  disconnect() {
    this.destroyCharts()
  }

  initCharts() {
    this.destroyCharts() // Clean up any existing charts first

    // Initialize Quotations by Status Chart (Donut)
    if (this.hasQuotationsByStatusTarget && this.hasQuotationsByStatusValue) {
      const data = this.quotationsByStatusValue

      if (this.hasData(data)) {
        this.charts.quotationsByStatus = this.createDonutChart(
          this.quotationsByStatusTarget,
          data,
          'Cotizaciones por Estado'
        )
      }
    }

    // Initialize Projects by Type Chart (Pie)
    if (this.hasProjectsByTypeTarget && this.hasProjectsByTypeValue) {
      const data = this.projectsByTypeValue

      if (this.hasData(data)) {
        this.charts.projectsByType = this.createPieChart(
          this.projectsByTypeTarget,
          data,
          'Proyectos por Tipo'
        )
      }
    }

    // Initialize Quotations by Month Chart (Line)
    if (this.hasQuotationsByMonthTarget && this.hasQuotationsByMonthValue) {
      const data = this.quotationsByMonthValue

      if (this.hasData(data)) {
        this.charts.quotationsByMonth = this.createLineChart(
          this.quotationsByMonthTarget,
          data,
          'Cotizaciones por Mes'
        )
      }
    }
  }

  createDonutChart(element, data, title) {
    const options = {
      chart: {
        type: 'donut',
        height: 350,
        fontFamily: 'inherit'
      },
      series: Object.values(data),
      labels: Object.keys(data).map(key => this.humanize(key)),
      colors: ['#0d6efd', '#6610f2', '#6f42c1', '#d63384', '#dc3545', '#fd7e14', '#ffc107', '#198754', '#20c997', '#0dcaf0'],
      legend: {
        position: 'bottom'
      },
      plotOptions: {
        pie: {
          donut: {
            labels: {
              show: true,
              total: {
                show: true,
                label: 'Total',
                formatter: () => Object.values(data).reduce((a, b) => a + b, 0)
              }
            }
          }
        }
      },
      responsive: [{
        breakpoint: 480,
        options: {
          chart: {
            width: 300
          },
          legend: {
            position: 'bottom'
          }
        }
      }]
    }

    const chart = new ApexCharts(element, options)
    chart.render()
    return chart
  }

  createPieChart(element, data, title) {
    const options = {
      chart: {
        type: 'pie',
        height: 350,
        fontFamily: 'inherit'
      },
      series: Object.values(data),
      labels: Object.keys(data).map(key => this.humanize(key)),
      colors: ['#198754', '#0d6efd', '#ffc107', '#dc3545', '#6610f2', '#0dcaf0'],
      legend: {
        position: 'bottom'
      },
      responsive: [{
        breakpoint: 480,
        options: {
          chart: {
            width: 300
          },
          legend: {
            position: 'bottom'
          }
        }
      }]
    }

    const chart = new ApexCharts(element, options)
    chart.render()
    return chart
  }

  createLineChart(element, data, title) {
    const { categories, seriesData } = this.parseMonthData(data)

    const options = {
      chart: {
        type: 'line',
        height: 350,
        fontFamily: 'inherit',
        toolbar: {
          show: true
        }
      },
      series: [{
        name: 'Cotizaciones',
        data: seriesData
      }],
      xaxis: {
        categories: categories,
        labels: {
          rotate: -45,
          rotateAlways: false
        }
      },
      stroke: {
        curve: 'smooth',
        width: 3
      },
      markers: {
        size: 5,
        hover: {
          size: 7
        }
      },
      colors: ['#0d6efd'],
      tooltip: {
        x: {
          format: 'MMM yyyy'
        }
      },
      grid: {
        borderColor: '#e7e7e7'
      }
    }

    const chart = new ApexCharts(element, options)
    chart.render()
    return chart
  }

  parseMonthData(data) {
    const categories = []
    const seriesData = []

    Object.entries(data).forEach(([key, value]) => {
      if (key && key !== 'null' && key !== 'undefined') {
        const date = new Date(key)

        if (!isNaN(date.getTime())) {
          // Format as "MMM YYYY" (e.g., "Nov 2024")
          const monthNames = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
            'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']
          categories.push(`${monthNames[date.getMonth()]} ${date.getFullYear()}`)
        } else {
          categories.push(key)
        }
      } else {
        categories.push('Sin fecha')
      }

      seriesData.push(value || 0)
    })

    return { categories, seriesData }
  }

  destroyCharts() {
    Object.values(this.charts).forEach(chart => {
      if (chart) {
        chart.destroy()
      }
    })
    this.charts = {}
  }

  hasData(data) {
    return data && Object.keys(data).length > 0 && Object.values(data).some(v => v > 0)
  }

  humanize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1).replace(/_/g, ' ')
  }
}

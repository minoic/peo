(() => {
  const roots = new Set();
  const script = document.createElement('script');
  script.src =
    'https://cdn.jsdelivr.net/npm/echarts@5.6.0/dist/echarts.min.js';
  script.async = true;
  script.onload = () => roots.forEach(renderLogo);
  document.head.appendChild(script);

  function renderLogo(element) {
    if (!window.echarts || element.__peoChart) return;

    element.textContent = '';
    const chart = window.echarts.init(element, null, {
      renderer: 'canvas',
      width: 68,
      height: 36,
    });
    chart.setOption({
      graphic: {
        elements: [
          {
            type: 'text',
            left: 'center',
            top: 'center',
            style: {
              text: 'PEO',
              fontFamily: 'Inter, Segoe UI, sans-serif',
              fontSize: 25,
              fontWeight: 'bold',
              lineDash: [0, 200],
              lineDashOffset: 0,
              fill: 'transparent',
              stroke: '#51B9FF',
              lineWidth: 1.5,
            },
            keyframeAnimation: {
              duration: 3000,
              loop: false,
              keyframes: [
                {
                  percent: 0.7,
                  style: {
                    fill: 'transparent',
                    lineDashOffset: 200,
                    lineDash: [200, 0],
                  },
                },
                {
                  percent: 0.8,
                  style: { fill: 'transparent' },
                },
                {
                  percent: 1,
                  style: { fill: '#FFFFFF' },
                },
              ],
            },
          },
        ],
      },
    });
    element.__peoChart = chart;
  }

  window.peoMountLogo = (element) => {
    element.setAttribute('aria-label', 'PEO');
    element.textContent = 'PEO';
    element.style.color = '#FFFFFF';
    element.style.font = '800 22px Inter, Segoe UI, sans-serif';
    element.style.lineHeight = '36px';
    roots.add(element);
    renderLogo(element);
  };
})();
